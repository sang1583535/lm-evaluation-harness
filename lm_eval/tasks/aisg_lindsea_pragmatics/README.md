# AISG LinDSEA Pragmatics Task

## Overview
The LinDSEA Pragmatics task evaluates models' understanding of pragmatic reasoning—how language is used to communicate meaning beyond literal semantic content. The task is split into **two distinct evaluation types**:
- **Single**: True/false judgment of individual statements (testing direct inference)
- **Pair**: Situation → conclusion inference (testing pragmatic entailment)

Each evaluation type requires different reasoning: simple factual correctness vs. pragmatic implicatures and context-dependent inference.

## Dataset
- **Source**: https://huggingface.co/datasets/aisingapore/Linguistic-Diagnostics-Pragmatics
- **Task Type**: Linguistic Diagnostics - Pragmatics
- **Languages**: 
  - Indonesian (id)
  - Tamil (ta)
- **Dataset Organization**: Each language has separate `{lang}_single` and `{lang}_pair` dataset splits

## Task Descriptions

### Pragmatic-Single: Direct Statement Evaluation
The model evaluates whether a simple statement is true or false in isolation or within a basic context.

**Task Structure**:
- Input: A statement/sentence
- Output: Select between two options (Benar/Salah for Indonesian, உண்மை/பொய் for Tamil)
- Focus: Direct logical inference, not pragmatic reasoning

**Example (Indonesian)**:
```
Text: X pintar tapi tidak jenius

Choices: Benar, Salah
```

**Dataset Fields**:
- `id`: Unique identifier
- `label`: Ground truth ("benar" or "salah")
- `prompts`: List containing single-type prompt:
  - `text`: The statement to evaluate
- `metadata`: Includes `linguistic_phenomenon`, `category`, `language`

### Pragmatic-Pair: Situation → Conclusion Inference
The model performs pragmatic inference, determining whether a conclusion follows from a given situation. This tests scalar implicatures, presuppositions, and contextual reasoning.

**Task Structure**:
- Input: A situation/context and a conclusion statement
- Output: Select whether the conclusion is True or False given the situation
- Focus: Pragmatic reasoning, conversational implicatures, contextual inference

**Example (Indonesian)**:
```
Situation: Tono membeli beberapa panci di toko
Conclusion: Tini masih bisa membeli panci di toko

Choices: Benar, Salah
```

In this example, the scalar implicature of "beberapa" (some) is that not all pans were bought, but this doesn't necessarily prevent others from buying pans.

**Dataset Fields**:
- `id`: Unique identifier
- `label`: Ground truth ("benar" or "salah")
- `prompts`: List containing pair-type prompt:
  - `text`: The situation/context
  - `conclusion`: The statement to evaluate for truthfulness
- `metadata`: Includes `linguistic_phenomenon`, `category`, `language`

## Configuration

### Single-Type Tasks
Each language YAML specifies:
- The statement as the input prompt
- Language-specific true/false choices
- Label mapping via `pragmatics_label_to_index()`

**Indonesian (id_single)**:
```yaml
include: aisg_lindsea_pragmatics_single_common_yaml
task: aisg_lindsea_pragmatics_single_id
dataset_name: id_single
doc_to_choice: ["Benar", "Salah"]
```

**Tamil (ta_single)**:
```yaml
include: aisg_lindsea_pragmatics_single_common_yaml
task: aisg_lindsea_pragmatics_single_ta
dataset_name: ta_single
doc_to_choice: ["உண்மை", "பொய்"]
```

### Pair-Type Tasks
Similar structure but includes both context and conclusion:

**Indonesian (id_pair)**:
```yaml
include: aisg_lindsea_pragmatics_pair_common_yaml
task: aisg_lindsea_pragmatics_pair_id
dataset_name: id_pair
doc_to_choice: ["Benar", "Salah"]
```

**Tamil (ta_pair)**:
```yaml
include: aisg_lindsea_pragmatics_pair_common_yaml
task: aisg_lindsea_pragmatics_pair_ta
dataset_name: ta_pair
doc_to_choice: ["உண்மை", "பொய்"]
```

### Common Configurations
**Single Tasks** (aisg_lindsea_pragmatics_single_common_yaml):
```yaml
dataset_path: aisingapore/Linguistic-Diagnostics-Pragmatics
dataset_name: null
output_type: multiple_choice
test_split: eval
doc_to_text: "{{prompts[0].text}}"
doc_to_target: !function utils.pragmatics_label_to_index
metric_list:
  - metric: acc
```

**Pair Tasks** (aisg_lindsea_pragmatics_pair_common_yaml):
```yaml
dataset_path: aisingapore/Linguistic-Diagnostics-Pragmatics
dataset_name: null
output_type: multiple_choice
test_split: eval
doc_to_text: "{{prompts[0].text}} {{prompts[0].conclusion}}"
doc_to_target: !function utils.pragmatics_label_to_index
metric_list:
  - metric: acc
```

## Utility Function

**`pragmatics_label_to_index(doc: dict) → int`**
- Maps "true"/"benar"/"உண்மை" → 0 (affirmative)
- Maps all other labels → 1 (negative)
- Returns integer index for correct metric calculation

## Pragmatic Phenomena Tested
The dataset covers various pragmatic reasoning phenomena including:
- **Scalar implicatures**: "Some" implies "not all"
- **Presuppositions**: Assumed truths in statements
- **Conversational maxims**: Grice's principles of cooperation
- **Context-dependent meaning**: Interpretation varies by situation
- **Entailment relationships**: Logical consequence across situations

## Usage

### Run Single-Type Tasks Only
```bash
# Both languages
lm-eval --tasks aisg_lindsea_pragmatics_single --model [model_name]

# Individual languages
lm-eval --tasks aisg_lindsea_pragmatics_single_id --model [model_name]
lm-eval --tasks aisg_lindsea_pragmatics_single_ta --model [model_name]
```

### Run Pair-Type Tasks Only
```bash
# Both languages
lm-eval --tasks aisg_lindsea_pragmatics_pair --model [model_name]

# Individual languages
lm-eval --tasks aisg_lindsea_pragmatics_pair_id --model [model_name]
lm-eval --tasks aisg_lindsea_pragmatics_pair_ta --model [model_name]
```

### Run All Pragmatics Tasks (Single + Pair)
```bash
lm-eval --tasks aisg_lindsea_pragmatics --model [model_name]
```

## Metrics
- **Accuracy**: For each task (single and pair), calculated separately using the built-in `acc` metric
- **Per-Language Aggregation**: Accuracy is aggregated across languages with equal weighting
- **Task-Type Aggregation**: Single and pair results are aggregated together under the main pragmatics group

## Aggregation and Reporting

The pragmatics group aggregates results from both **single and pair tasks** because:
- They test related pragmatic reasoning capabilities
- Both use the same evaluation metric (acc)
- Results are reported together for overall pragmatic understanding

**Note**: In the original SEA-HELM framework, results are further broken down by **linguistic phenomenon** (scalar implicatures, presuppositions, etc.). The current lm-evaluation-harness implementation reports overall accuracy; per-phenomenon analysis would require custom metric implementation.

## Task Type Comparison

| Aspect | Single | Pair |
|--------|--------|------|
| **Reasoning Type** | Direct logical inference | Pragmatic inference with context |
| **Input Structure** | Statement only | Situation + conclusion |
| **Complexity** | Lower - direct factuality | Higher - requires contextual understanding |
| **Dataset Split** | `{lang}_single` | `{lang}_pair` |
| **Choices** | Benar/Salah (Indonesian) or உண்மை/பொய் (Tamil) | Same |

## Key Features
- **Declarative configuration**: Prompts built with Jinja templates, not Python functions
- **Type-correct mapping**: `doc_to_target` returns integers (0/1) for proper metric calculation
- **Standard metric**: Uses built-in LM-Eval accuracy metric (`acc`)
- **Language-specific choices**: Each language uses native-language true/false terminology
- **Clear task separation**: Single and pair tasks have separate common configurations

## Important Notes
- **Combined Reporting**: Single and pair tasks are aggregated in the overall pragmatics score (following SEA-HELM design)
- **Language-Specific Phrasing**: Both Indonesian and Tamil versions use culturally and linguistically appropriate choice labels
- **Binary Choice**: Both task types use binary (true/false) choice format
- **Pragmatic Knowledge**: Pair-type tasks require deeper pragmatic reasoning than single-type tasks
- **Phenomenon-Based Analysis**: Original SEA-HELM reports results broken down by linguistic phenomena (available in metadata)

## References
- Lin-DSEA Pragmatics Dataset: https://huggingface.co/datasets/aisingapore/Linguistic-Diagnostics-Pragmatics
- BHASA: The Holistic Southeast Asian Linguistic and Cultural Evaluation Suite
  https://arxiv.org/abs/2309.06085
- Grice, H. P. (1975). "Logic and Conversation". Syntax and Semantics 3: Speech Acts.

## Task Characteristics
- **Task Type**: Binary Multiple Choice (True vs False)
- **Split Used**: eval (test set)
- **Evaluation Metric**: Accuracy per task type (using `acc` metric)
- **Linguistic Challenge**: Pragmatic reasoning beyond literal semantics
- **Difficulty**: High for pair-type; Medium for single-type
