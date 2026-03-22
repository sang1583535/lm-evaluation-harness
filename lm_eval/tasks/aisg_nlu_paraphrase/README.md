# AISG NLU Paraphrase Identification Task

## Overview

The paraphrase identification task is a **binary classification task** that determines whether two sentences are paraphrases of each other. This is part of AI Singapore's Natural Language Understanding (NLU) evaluation suite for Southeast Asian languages.

A paraphrase is a statement that expresses the same meaning in different words. The model must classify sentence pairs as either:
- **Paraphrase (Index 0)**: The two sentences have essentially the same meaning
- **Non-Paraphrase (Index 1)**: The two sentences differ in meaning or nuance

## Datasets

This task uses locally-hosted JSONL files from annotated paraphrase identification datasets:

| Language | Dataset | Size | Source |
|----------|---------|------|--------|
| Burmese (my) | MyParaphrase | ~1,096 test examples | Facebook Research FLORES |
| Filipino (tl) | PAWS | ~4,000+ test examples | Google Research |

## Dataset Structure

Each example in the JSONL files contains:

```json
{
  "id": "unique_identifier",
  "label": "A" or "B",
  "text_label": "paraphrase" or "non-paraphrase",
  "prompts": [
    {
      "sentence1": "First sentence in the pair",
      "sentence2": "Second sentence in the pair"
    }
  ],
  "metadata": {
    "language": "my" or "tl"
  }
}
```

**Field Descriptions:**
- `id`: Unique identifier for the example
- `label`: Language-specific label character (A/B)
- `text_label`: Ground truth label ("paraphrase" or "non-paraphrase")
- `prompts`: Contains a single prompt object with two sentences to compare
- `metadata`: Contains language and source information

## Task Configuration

### Input Format
The model receives both sentences concatenated with a space:
```
sentence1 sentence2
```

### Answer Choices
Each language provides native-language labels for the choices:

| Language | Paraphrase | Non-Paraphrase |
|----------|-----------|-----------------|
| Burmese | အဓိပ္ပာယ်တူ | အဓိပ္ပာယ်တူမဟုတ် |
| Filipino | Paraphrase | Hindi paraphrase |

**Choice indices:**
- Index 0: Paraphrase (yes)
- Index 1: Non-Paraphrase (no)

### Metrics
- **Metric**: Accuracy (`acc`)
- **Aggregation**: Mean (with size weighting across languages)

## Configuration Files

### File Structure
```
aisg_nlu_paraphrase/
├── task.py                           # Custom task class for JSONL loading
├── utils.py                          # Language config & generation utilities
├── aisg_nlu_paraphrase_common_yaml   # Shared configuration
├── aisg_nlu_paraphrase_my.yaml       # Burmese-specific config
├── aisg_nlu_paraphrase_tl.yaml       # Filipino-specific config
├── README.md                         # This file
└── data/
    ├── my_myparaphrase.jsonl        # Burmese test data
    └── tl_paws.jsonl                # Filipino test data
```

### Common Configuration
The `aisg_nlu_paraphrase_common_yaml` file contains shared settings:
- `output_type: multiple_choice` - Binary classification task
- `test_split: test` - Evaluation uses test data
- `doc_to_text`: Template that concatenates both sentences
- `doc_to_target: !function utils.doc_to_target` - Maps labels to choice indices
- `metric_list: [acc]` - Uses accuracy metric with size weighting

### Language-Specific Configuration
Each language file (`aisg_nlu_paraphrase_{my,tl}.yaml`) specifies:
- `class: !function task.ParaphraseIdentificationTask` - Task instantiation
- `dataset_name`: Maps to JSONL file (e.g., "my_myparaphrase", "tl_paws")
- `task`: Task identifier for evaluation tracking
- `doc_to_choice`: Language-specific answer labels
- `include: aisg_nlu_paraphrase_common_yaml` - Includes common config

## Usage

### Evaluate a Single Language

```bash
# Evaluate on Burmese paraphrase identification
lm-eval --tasks aisg_nlu_paraphrase_my --model [model_name]

# Evaluate on Filipino paraphrase identification
lm-eval --tasks aisg_nlu_paraphrase_tl --model [model_name]
```

### Evaluate All Languages Together

```bash
# Evaluate on all paraphrase identification tasks
lm-eval --tasks aisg_nlu_paraphrase --model [model_name]
```

### Example Output

```
Task: aisg_nlu_paraphrase
Results:
  aisg_nlu_paraphrase_my,acc: 0.8234
  aisg_nlu_paraphrase_tl,acc: 0.7891
  aisg_nlu_paraphrase,acc: 0.7956  (weighted average)
```

## Implementation Details

### Task Class (`task.py`)
The `ParaphraseIdentificationTask` class:
1. Maps dataset names to local JSONL files
2. Loads examples from JSONL data directory
3. Provides test documents for evaluation
4. Supports multiple languages via dataset_name configuration

### Utility Functions (`utils.py`)
- **LANGUAGES**: Dictionary mapping dataset names to language configurations with native labels
- **doc_to_target()**: Converts text labels ("paraphrase"/"non-paraphrase") to choice indices (0/1)
- **gen_lang_yamls()**: Script to generate language-specific YAML configuration files

### Label Mapping
```python
"paraphrase" -> 0
"non-paraphrase" -> 1
```

## Data Format Compatibility

The task automatically loads data from JSONL files specified in language-specific configurations:
- **aisg_nlu_paraphrase_my**: Maps to `data/my_myparaphrase.jsonl`
- **aisg_nlu_paraphrase_tl**: Maps to `data/tl_paws.jsonl`

JSONL files must maintain the structure described in the [Dataset Structure](#dataset-structure) section with properly formatted prompts and labels.

## Performance Expectations

- **Burmese dataset** (MyParaphrase): ~1K examples, challenging baseline
- **Filipino dataset** (PAWS): ~4K examples, diverse and well-balanced
- **Target performance**: >75% accuracy on both datasets indicates strong multilingual paraphrase understanding

## References

- **MyParaphrase**: Facebook Research FLORES - https://github.com/facebookresearch/flores
- **PAWS**: Google Research Paraphrase Adversarial Word Ordering - https://github.com/google-research-datasets/paws
- **SEA-HELM**: AI Singapore Benchmark Suite - https://github.com/aisingapore/BHASA

## Consistency with NLI Task

This task follows the same structural patterns as the improved `aisg_nlr_nli` task:
- Language-specific answer choices with native labels
- Simple doc_to_text template concatenating input pairs
- Integer-returning doc_to_target function
- Minimal language-specific YAML files with common configuration inheritance
- Standard `acc` metric for aggregation


## Data Loading
The task uses custom JSONL data files located in the `data/` subdirectory. A custom task class (`ParaphraseIdentificationTask`) handles loading the data from these local files rather than fetching from HuggingFace.
