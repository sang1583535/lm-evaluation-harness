# AISG NLU Metaphor Identification Task

## Overview
The metaphor identification task tests the model's ability to understand figurative language and metaphorical expressions. The task differs by language:
- **Indonesian**: Choose between two candidate interpretations of a metaphorical phrase
- **Tamil**: Determine whether a given explanation of a metaphor is true or false

## Dataset
- **Source**: https://huggingface.co/datasets/aisingapore/NLU-Metaphor
- **Languages**: 
  - Indonesian (id)
  - Tamil (ta)

## Task Structure

### Indonesian Task
Given a metaphorical phrase and two possible interpretations, the model must select the correct one:
- **Prompt**: The metaphorical phrase (e.g., "Nyalinya seperti anak kecil yang tersesat." / "His courage is like a lost child.")
- **Choices**: 
  - Choice 0: `choice1` - the first interpretation
  - Choice 1: `choice2` - the second interpretation
- **Label Mapping**: "A" → 0, "B" → 1

**Example**:
```
Phrase: "Nyalinya seperti anak kecil yang tersesat."
Choice 0: "Dia penakut." (He is cowardly)
Choice 1: "Dia pemberani." (He is brave)
Correct: A (index 0)
```

### Tamil Task
Given a metaphor and a proposed explanation, determine whether the explanation is true or false:
- **Prompt**: The metaphor + the explanation (e.g., "மெய்யான பொருளை விளக்குதல் / Actual explanation")
- **Choices**: 
  - Choice 0: "உண்மை" (True)
  - Choice 1: "பொய்" (False)
- **Label Mapping**: "true" → 0, "false" → 1

## Configuration

Each language YAML file is self-contained and can be run independently:

### Indonesian YAML
```yaml
include: aisg_nlu_metaphor_common_yaml
task: aisg_nlu_metaphor_id
dataset_name: id
doc_to_text: "{{prompts[0].phrase}}"
doc_to_choice: "{{[prompts[0].choice1, prompts[0].choice2]}}"
doc_to_target: !function utils.metaphor_label_to_index
```

### Tamil YAML
```yaml
include: aisg_nlu_metaphor_common_yaml
task: aisg_nlu_metaphor_ta
dataset_name: ta
doc_to_text: "{{prompts[0].metaphor}} {{prompts[0].explanation}}"
doc_to_choice: ["உண்மை", "பொய்"]
doc_to_target: !function utils.metaphor_truth_to_index
```

### Common Configuration
The shared configuration sets:
- Dataset path and split
- Multiple-choice output type
- Accuracy metric with size weighting

## Utility Functions

**`metaphor_label_to_index(doc: dict) → int`**
- Indonesian: Maps label "A"/"B" to 0/1

**`metaphor_truth_to_index(doc: dict) → int`**
- Tamil: Maps label "true"/"false" to 0/1

## Usage

```bash
# Indonesian only
lm-eval --tasks aisg_nlu_metaphor_id --model [model]

# Tamil only
lm-eval --tasks aisg_nlu_metaphor_ta --model [model]

# Both languages (aggregated)
lm-eval --tasks aisg_nlu_metaphor --model [model]
```

## Metrics
- **Accuracy**: Percentage of examples correctly classified, aggregated across languages with size weighting

## Dataset Statistics
- Indonesian (id): ~500-1000 test examples
- Tamil (ta): ~500-1000 test examples

## Key Features
- **Language-specific structure**: Each YAML reflects the actual data structure for its language
- **Declarative configuration**: Prompts and choices defined inline using Jinja templates
- **Type-correct mapping**: `doc_to_target` returns integers (0/1), not strings
- **Standard metric**: Uses built-in LM-Eval accuracy metric

## References
- NLU-Metaphor Dataset: https://huggingface.co/datasets/aisingapore/NLU-Metaphor
- BHASA: The Holistic Southeast Asian Linguistic and Cultural Evaluation Suite
  https://arxiv.org/abs/2309.06085

## Dataset Field Reference

### Indonesian
```json
{
  "id": "...",
  "prompts": [{
    "phrase": "The metaphorical phrase",
    "choice1": "First interpretation",
    "choice2": "Second interpretation"
  }],
  "label": "A" or "B",
  "metadata": {...}
}
```

### Tamil
```json
{
  "id": "...",
  "prompts": [{
    "metaphor": "The metaphor",
    "explanation": "Proposed explanation"
  }],
  "label": "true" or "false",
  "metadata": {...}
}
```
