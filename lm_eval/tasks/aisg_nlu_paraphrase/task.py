"""
Paraphrase Identification Task for aisg_nlu_paraphrase.

This task loads paraphrase identification data from local JSONL files.
The dataset is used to evaluate how well models can identify whether two sentences
are paraphrases of each other.
"""

import os
import json

from lm_eval.api.task import ConfigurableTask


class ParaphraseIdentificationTask(ConfigurableTask):
    """
    Custom task for loading paraphrase identification data from local JSONL files.
    
    This task evaluates binary classification of sentence pairs as paraphrases
    or non-paraphrases across multiple Southeast Asian languages.
    """

    # Mapping of dataset names to local JSONL files
    DATASET_MAP = {
        "my_myparaphrase": "my_myparaphrase.jsonl",
        "tl_paws": "tl_paws.jsonl",
    }

    def _get_data_path(self) -> str:
        """Get the path to the JSONL data file based on dataset_name."""
        dataset_name = self.config.dataset_name
        
        if dataset_name not in self.DATASET_MAP:
            raise ValueError(
                f"Unsupported dataset: {dataset_name}. "
                f"Supported datasets: {list(self.DATASET_MAP.keys())}"
            )
        
        task_dir = os.path.dirname(os.path.abspath(__file__))
        data_file = self.DATASET_MAP[dataset_name]
        return os.path.join(task_dir, "data", data_file)

    def _load_data(self) -> list:
        """Load all examples from the JSONL file."""
        data_path = self._get_data_path()
        
        if not os.path.exists(data_path):
            raise FileNotFoundError(f"Data file not found: {data_path}")
        
        examples = []
        with open(data_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    example = json.loads(line)
                    examples.append(example)
        
        return examples

    def load_docs(self) -> list:
        """Load all documents (examples) for the task."""
        return self._load_data()

    def has_training_docs(self) -> bool:
        """This task only has test documents."""
        return False

    def has_validation_docs(self) -> bool:
        """This task only has test documents."""
        return False

    def has_test_docs(self) -> bool:
        """This task has test documents."""
        return True

    def test_docs(self) -> list:
        """Return all test documents."""
        return self.load_docs()
