"""
Utility functions for SeaEval cross-MMLU evaluation.
Removes (A), (B), (C), (D) prefixes from answers and choices.
Follows xcopa pattern with functions callable from YAML configs.
"""

import json
from functools import partial
from pathlib import Path
from datasets import load_dataset


LANGUAGES = {
    'English': 'en',
    'Chinese': 'zh',
    'Vietnamese': 'vi',
    'Indonesian': 'id',
    'Malay': 'ms',
    'Filipino': 'tl',
}


def remove_prefix(text):
    """Remove (A), (B), (C), (D) prefixes from text."""
    text = str(text).strip()
    for prefix in ['(A) ', '(B) ', '(C) ', '(D) ']:
        if text.startswith(prefix):
            return text[4:].strip()
    return text


def doc_to_text(doc, language_field):
    """Format question for evaluation."""
    lang_data = doc.get(language_field, {})
    question = lang_data.get('question', '')

    return f"{question}\n"


def doc_to_choice(doc, language_field):
    """Return choices (with prefixes removed) for multiple choice."""
    lang_data = doc.get(language_field, {})
    choices = lang_data.get('choices', [])
    return [remove_prefix(c) for c in choices]


def doc_to_target(doc, language_field):
    """Return target answer (with prefix removed)."""
    lang_data = doc.get(language_field, {})
    answer = lang_data.get('answer', '')
    return remove_prefix(answer)


# Language-specific functions using partial
doc_to_text_en = partial(doc_to_text, language_field='English')
doc_to_text_zh = partial(doc_to_text, language_field='Chinese')
doc_to_text_vi = partial(doc_to_text, language_field='Vietnamese')
doc_to_text_id = partial(doc_to_text, language_field='Indonesian')
doc_to_text_ms = partial(doc_to_text, language_field='Malay')
doc_to_text_tl = partial(doc_to_text, language_field='Filipino')

doc_to_choice_en = partial(doc_to_choice, language_field='English')
doc_to_choice_zh = partial(doc_to_choice, language_field='Chinese')
doc_to_choice_vi = partial(doc_to_choice, language_field='Vietnamese')
doc_to_choice_id = partial(doc_to_choice, language_field='Indonesian')
doc_to_choice_ms = partial(doc_to_choice, language_field='Malay')
doc_to_choice_tl = partial(doc_to_choice, language_field='Filipino')

doc_to_target_en = partial(doc_to_target, language_field='English')
doc_to_target_zh = partial(doc_to_target, language_field='Chinese')
doc_to_target_vi = partial(doc_to_target, language_field='Vietnamese')
doc_to_target_id = partial(doc_to_target, language_field='Indonesian')
doc_to_target_ms = partial(doc_to_target, language_field='Malay')
doc_to_target_tl = partial(doc_to_target, language_field='Filipino')