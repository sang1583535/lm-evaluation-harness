# lm_eval/tasks/indic_sentiment_ta/utils.py
from typing import Dict
import datasets
import json
import urllib.request

LABELS = ["negative", "positive"]  # Tamil: 2-class only

def process_docs(dataset: datasets.Dataset) -> datasets.Dataset:
    """
    Normalize IndicSentiment Tamil rows for lm-eval:

    1. Filter out rows where LABEL or INDIC REVIEW is missing
       or LABEL is not in {"negative", "positive"}.
    2. Add:
        - text      : Tamil review text
        - label     : normalized string label
        - label_idx : index into LABELS
    """

    # ---- 1) FILTER: decide which rows to keep ----
    def _keep(example: Dict) -> bool:
        text = example.get("INDIC REVIEW", None)
        label_val = example.get("LABEL", None)

        if text is None or label_val is None:
            return False

        label_str = str(label_val).strip().lower()
        return label_str in LABELS

    dataset = dataset.filter(_keep)

    # ---- 2) MAP: transform kept rows (no dropping here) ----
    def _proc(example: Dict) -> Dict:
        text = example["INDIC REVIEW"]
        label_str = str(example["LABEL"]).strip().lower()

        return {
            # keep only what we need; you can also add other original fields if you like
            "text": text,
            "label": label_str,
            "label_idx": LABELS.index(label_str),
        }

    dataset = dataset.map(_proc)

    return dataset


def custom_dataset_loader(language: str = "ta", **kwargs) -> datasets.DatasetDict:
    """
    Load IndicSentiment dataset directly from JSON files to bypass script-based loader.
    
    Args:
        language: Language code (default: 'ta' for Tamil)
    
    Returns:
        datasets.DatasetDict with validation and test splits
    """
    base_url = "https://huggingface.co/datasets/ai4bharat/IndicSentiment/resolve/main/data"
    
    dataset_dict = {}
    splits = ["validation", "test"]
    
    for split in splits:
        json_url = f"{base_url}/{split}/{language}.json"
        
        try:
            with urllib.request.urlopen(json_url) as response:
                content = response.read().decode('utf-8').strip()
                
            # Handle both JSONL (newline-delimited) and regular JSON formats
            if content.startswith('['):
                # Regular JSON array
                data = json.loads(content)
            else:
                # JSONL format (one JSON object per line)
                lines = content.split('\n')
                data = [json.loads(line) for line in lines if line.strip()]
            
            # Convert list of dicts to dataset
            if data:
                dataset_dict[split] = datasets.Dataset.from_dict({
                    k: [item.get(k) for item in data]
                    for k in data[0].keys()
                })
        except Exception as e:
            print(f"Warning: Could not load {split} split for {language}: {e}")
            continue
    
    return datasets.DatasetDict(dataset_dict)
