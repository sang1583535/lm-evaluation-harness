"""Custom dataset loader for NusaX-senti to bypass script-based loader issues."""
import datasets
import pandas as pd
import io
import urllib.request


# Language code to full name mapping from the original script
LANGUAGES_MAP = {
    "ace": "acehnese",
    "ban": "balinese",
    "bjn": "banjarese",
    "bug": "buginese",
    "eng": "english",
    "ind": "indonesian",
    "jav": "javanese",
    "mad": "madurese",
    "min": "minangkabau",
    "nij": "ngaju",
    "sun": "sundanese",
    "bbc": "toba_batak",
}


def custom_dataset_loader(language: str = "ind", **kwargs) -> datasets.DatasetDict:
    """
    Load NusaX-senti dataset directly from GitHub CSV files without using the script.
    
    Args:
        language: Language code (default: 'ind' for Indonesian)
    
    Returns:
        datasets.DatasetDict with train, validation, and test splits
    """
    base_url = "https://raw.githubusercontent.com/IndoNLP/nusax/main/datasets/sentiment"
    lang_name = LANGUAGES_MAP.get(language, language)
    
    dataset_dict = {}
    splits = ["train", "valid", "test"]
    split_names = ["train", "validation", "test"]
    
    for split, split_name in zip(splits, split_names):
        csv_url = f"{base_url}/{lang_name}/{split}.csv"
        
        try:
            # Download and read CSV file with pandas
            with urllib.request.urlopen(csv_url) as response:
                csv_data = io.StringIO(response.read().decode('utf-8'))
            
            df = pd.read_csv(csv_data)
            
            # Convert to datasets.Dataset
            dataset_dict[split_name] = datasets.Dataset.from_pandas(df)
        except Exception as e:
            print(f"Warning: Could not load {split} split for {language}: {e}")
            continue
    
    return datasets.DatasetDict(dataset_dict)


