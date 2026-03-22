"""
Utility functions for the paraphrase identification task.

This module provides helper functions for the paraphrase identification task
using HuggingFace's built-in json dataset loader. No custom task class is needed.
"""




def doc_to_target(doc) -> int:
    """
    Map the text_label field to the index of the correct choice.
    
    Maps "paraphrase" and "non-paraphrase" labels to choice indices:
    - "paraphrase" -> 0 (choice A)
    - "non-paraphrase" -> 1 (choice B)
    
    The harness expects an integer index, not a string.
    
    Args:
        doc: Document dictionary with 'text_label' field
        
    Returns:
        int: Index of the correct choice (0 or 1)
    """
    label_to_index = {
        "paraphrase": 0,
        "non-paraphrase": 1,
    }
    
    text_label = doc.get("text_label", "").strip().lower()
    return label_to_index.get(text_label, 1)
