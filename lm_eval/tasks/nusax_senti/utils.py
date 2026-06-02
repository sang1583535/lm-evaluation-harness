"""Custom dataset loader for NusaX-senti to bypass script-based loader issues."""
import datasets
import pandas as pd
import io
import urllib.request


LANGUAGE_NAMES = {
    "ace": "Acehnese",
    "ban": "Balinese",
    "bjn": "Banjarese",
    "bug": "Buginese",
    "eng": "English",
    "ind": "Indonesian",
    "jav": "Javanese",
    "mad": "Madurese",
    "min": "Minangkabau",
    "nij": "Ngaju",
    "sun": "Sundanese",
    "bbc": "Toba Batak",
}


EN_PROMPT = """Classify the sentiment of the following text.
Choose one of the following options:
A. negative
B. neutral
C. positive

Text: {text}
Answer:"""


OG_PROMPTS = {
    "eng": EN_PROMPT,
    "ind": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "jav": """Temtokake sentimen saka teks ing ngisor iki.
Pilih salah siji opsi ing ngisor iki:
A. negative
B. neutral
C. positive

Teks: {text}
Wangsulan:""",
    "sun": """Tangtukeun sentimen tina teks ieu.
Pilih salah sahiji opsi ieu:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "min": """Tantukan sentimen dari teks barikuik.
Pilih salah ciek opsi barikuik:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    # For languages where we are less confident, use Indonesian-like prompt.
    "ace": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "ban": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "bjn": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "bug": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "mad": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "nij": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
    "bbc": """Tentukan sentimen dari teks berikut.
Pilih salah satu opsi berikut:
A. negative
B. neutral
C. positive

Teks: {text}
Jawaban:""",
}


def doc_to_text_en(doc):
    return EN_PROMPT.format(text=doc["text"])


def doc_to_text_og(doc):
    lang = doc.get("lang", "ind")
    prompt = OG_PROMPTS.get(lang, OG_PROMPTS["ind"])
    return prompt.format(text=doc["text"])


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


