# AISG NLR-NLI Task

## Overview
The NLR-NLI (Natural Language Reasoning - Natural Language Inference) task is a multilingual NLI task covering seven Southeast Asian and South Asian languages.

## Dataset
- **Source**: https://huggingface.co/datasets/aisingapore/NLR-NLI
- **Languages**: 
  - Indonesian (id) - from IndoNLI
  - Malay (ms)
  - Burmese (my)
  - Tamil (ta) - from IndicXNLI  
  - Thai (th) - from XNLI
  - Filipino/Tagalog (tl)
  - Vietnamese (vi) - from XNLI

## Task Description
Natural Language Inference (NLI) is the task of determining the relationship between a premise and hypothesis. The three classes are:
- **Entailment**: The hypothesis is necessarily true given the premise
- **Contradiction**: The hypothesis is necessarily false given the premise
- **Neutral**: The hypothesis may or may not be true given the premise

## Dataset Structure
Each example contains:
- `prompts`: List of premise-hypothesis pairs (each with `sentence1` and `sentence2`)
- `label`: Ground truth label ("A", "B", or "C")
- `text_label`: Text representation of the label ("entailment", "contradiction", or "neutral")
- `metadata`: Dictionary containing language information
- `id`: Unique identifier

## Dataset Statistics
- Indonesian (id): ~1,000 test examples
- Malay (ms): ~1,000 test examples
- Burmese (my): ~1,000 test examples
- Tamil (ta): ~1,000 test examples
- Thai (th): ~1,000 test examples
- Filipino (tl): ~1,000 test examples
- Vietnamese (vi): ~1,000 test examples

## Usage
To run the task:
```bash
# Individual languages
lm-eval --tasks aisg_nlr_nli_id --model [model_name]
lm-eval --tasks aisg_nlr_nli_th --model [model_name]

# All languages together
lm-eval --tasks aisg_nlr_nli --model [model_name]
```

## Metrics
- Accuracy (aggregated across all languages with size weighting)

## References
- IndoNLI: https://aclanthology.org/2021.emnlp-main.821
- IndicXNLI: https://aclanthology.org/2022.emnlp-main.755/
- XNLI: https://aclanthology.org/D18-1269/
- BHASA: https://arxiv.org/abs/2309.06085
