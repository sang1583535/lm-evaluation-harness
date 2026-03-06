# AISG LinDSEA Syntax (Linguistic Diagnostics) Task

## Overview
The LinDSEA Syntax task evaluates models' understanding of grammatical correctness through minimal pair comparisons. Given two sentences differing in a specific linguistic phenomenon, the model must identify which sentence is grammatically correct. This task tests deep syntactic and linguistic knowledge across multiple Southeast Asian languages.

## Dataset
- **Source**: https://huggingface.co/datasets/aisingapore/Linguistic-Diagnostics-Syntax
- **Task Type**: Linguistic Diagnostics
- **Languages**: 
  - Indonesian (id)
  - Tamil (ta)

## Task Structure

Both languages follow the same multiple-choice format with language-specific questions:

### Indonesian Task
```
Prompt:
A: Tono tahu apa-apa
B: Tono tidak tahu apa-apa

Kalimat mana yang lebih mungkin?

Choices: A, B
Correct: B
```

### Tamil Task
```
Prompt:
[Tamil sentence pair]

எந்த வாக்கியம் மிகவும் சாத்தியமானது?

Choices: A, B
Correct: A or B
```

## Configuration

Each language YAML is self-contained and specifies:
- The sentence pair as the prompt
- A localized question in the target language
- Simple "A" and "B" choices
- Label mapping via `lindsea_target_to_index()`

### Indonesian YAML
```yaml
include: aisg_lindsea_syntax_common_yaml
task: aisg_lindsea_syntax_id
dataset_name: id
doc_to_text: "{{prompts[0].sentence_pair}}\n\nKalimat mana yang lebih mungkin?"
doc_to_choice: ["A", "B"]
```

### Tamil YAML
```yaml
include: aisg_lindsea_syntax_common_yaml
task: aisg_lindsea_syntax_ta
dataset_name: ta
doc_to_text: "{{prompts[0].sentence_pair}}\n\nஎந்த வாக்கியம் மிகவும் சாத்தியமானது?"
doc_to_choice: ["A", "B"]
```

### Common Configuration
Base settings shared across all languages:
- Dataset path and split
- Multiple-choice output type
- `lindsea_target_to_index` function for label mapping
- Accuracy metric with size weighting

## Utility Functions

**`lindsea_target_to_index(doc: dict) → int`**
- Maps label "A" → 0, "B" → 1
- Returns integer index (not string) for proper metric calculation

## Dataset Structure
Each example contains:
- `id`: Unique identifier
- `label`: Correct answer ("A" or "B")
- `prompts`: List containing:
  - `sentence_pair`: Two sentences formatted as:
    ```
    A: <sentence_a>
    B: <sentence_b>
    ```
- `metadata`: Dictionary containing:
  - `language`: Language code (id/ta)
  - `linguistic_phenomenon`: Category of linguistic phenomenon
  - Other metadata fields for analysis

## Linguistic Phenomena Tested
The dataset covers various linguistic phenomena including:
- NPI (Negative Polarity Item) licensing
- Agreement violations
- Tense and aspect marking
- Case marking
- Word order constraints
- And other syntactic features

## Example (Indonesian)
```
Sentence Pair:
A: Tono tahu apa-apa
B: Tono tidak tahu apa-apa

Question (in Indonesian): Kalimat mana yang lebih mungkin? (Which sentence is more likely?)
Choices: A, B
Correct: B

Linguistic Phenomenon: NPIs and negation (NPI licensing)
```

In this example, "apa-apa" (anything) is a Negative Polarity Item that requires negation context. Only sentence B is grammatically correct.

## Dataset Statistics
- Indonesian (id): Multiple minimal pairs covering various syntactic phenomena
- Tamil (ta): Multiple minimal pairs covering various syntactic phenomena

## Usage

```bash
# Individual languages
lm-eval --tasks aisg_lindsea_syntax_id --model [model_name]
lm-eval --tasks aisg_lindsea_syntax_ta --model [model_name]

# All languages together (with aggregated results)
lm-eval --tasks aisg_lindsea_syntax --model [model_name]
```

## Metrics
- **Accuracy**: Percentage of examples correctly classified, aggregated across languages with size weighting

## Key Features
- **Language-specific questions**: Each YAML includes a naturally-phrased question in the target language
- **Simple choices**: Uses straightforward "A" and "B" options, avoiding unnecessary translations
- **Type-correct mapping**: `doc_to_target` returns integers (0/1), not strings
- **Standard metric**: Uses built-in LM-Eval accuracy metric (`acc`)

## References
- LinDSEA Syntax Dataset: https://huggingface.co/datasets/aisingapore/Linguistic-Diagnostics-Syntax
- BHASA: The Holistic Southeast Asian Linguistic and Cultural Evaluation Suite
  https://arxiv.org/abs/2309.06085

## Task Characteristics
- **Task Type**: Binary Multiple Choice (A vs B)
- **Split Used**: eval (test set)
- **Evaluation Metric**: Accuracy
- **Linguistic Challenge**: Grammatical correctness, syntactic knowledge
- **Difficulty**: High - requires deep linguistic understanding

## Notes
- Each pair tests a specific syntactic phenomenon or constraint
- The minimal pair approach ensures that differences are due to specific linguistic features
- Models need to understand grammar rules, not just surface patterns
- The task is particularly challenging because both sentences may seem "natural" to non-native speakers or models
- Configuration is declarative (Jinja templates) rather than imperative (Python functions) for clarity and maintainability
