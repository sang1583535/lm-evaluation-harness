"""
Utility functions for LinDSEA Pragmatics tasks.
"""


def pragmatics_label_to_index(doc: dict) -> int:
    """
    Map the dataset's label to a binary index:
      - return 0 if the label indicates the statement is true
      - return 1 if the label indicates it is false
    
    Handles labels in multiple languages:
      - English: "true", "false"
      - Indonesian: "benar", "salah"
      - Tamil: "உண்மை" (true), "பொய்" (false)
    """
    label = doc.get("label", "").strip().lower()
    positive_labels = {"true", "benar", "உண்மை", "a"}
    return 0 if label in positive_labels else 1
