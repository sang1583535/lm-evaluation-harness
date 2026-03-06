"""
Utility functions for LinDSEA Syntax task.
"""


def lindsea_target_to_index(doc: dict) -> int:
    """
    LinDSEA Syntax task: map label 'A' or 'B' to 0 or 1.
    
    A (first sentence) → 0
    B (second sentence) → 1
    """
    label = doc.get("label", "").strip().upper()
    return 0 if label == "A" else 1
