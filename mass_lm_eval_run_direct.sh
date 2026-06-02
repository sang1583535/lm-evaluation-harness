#!/bin/bash

MODELS=(
    # "/scratch/e1583535/llm/nus-olmo/mixed-n10B"
    # "/scratch/e1583535/llm/nus-olmo/para-first-n10B"
    # "/scratch/e1583535/llm/nus-olmo/para-last-n10B-rerun"
    # "/scratch/e1583535/llm/nus-olmo/multi-uniform-n10B-SEA-7.5_replay-2.5-checkpoints/step4770-unsharded-hf-multi-uniform"
    # "/scratch/e1583535/llm/nus-olmo/multilingual-n10B-7.5-replay-2.5-checkpoints/step4770-unsharded-hf-multilingual"
    # "/scratch/e1583535/llm/nus-olmo/para-replay-n10B"
    # "/scratch/e1583535/llm/nus-olmo/para-only-34B8"
    # "/scratch/e1583535/llm/nus-olmo/multilingual-uniform-7B_n34.8-26_replay-8.7-checkpoints/step8290-unsharded-hf-multilingual-uniform-34.7B"
    # "/scratch/e1583535/llm/nus-olmo/multilingual-7B_n34.8-26_replay-8.7-checkpoints/step8290-unsharded-hf-multilingual-7B-34.7B"
    # "/scratch/e1583535/llm/nus-olmo/para-only-7B-34B-checkpoints/step8290-unsharded-hf-para-only-7B-34.7B"
    # "SeaLLMs/SeaLLMs-v3-1.5B"
    # "sail/Sailor2-L-1B"
    # "meta-llama/Llama-3.1-8B-Instruct"
    # "SeaLLMs/SeaLLMs-v3-7B"
    # "sail/Sailor2-8B"
    # "aisingapore/Llama-SEA-LION-v3.5-8B-R"
    # "allenai/OLMo-2-1124-7B"
    # "/scratch/e1583535/llm/sail/Sailor2-20B"
    # "aisingapore/Gemma-SEA-LION-v4-27B"
    # "aisingapore/Qwen-SEA-LION-v4-32B-IT"  
    # "/scratch/e1583535/llm/openseal-sft/openseal-sailor2ds-stage1"
    # "/scratch/e1583535/llm/openseal-sft/openseal-sailor2ds-stage2"
    # "/scratch/e1583535/llm/openseal-sft/openseal-seaexam-stage3"
    # "/scratch/e1583535/llm/openseal-sft/openseal-seaexam-stage3-cosmos"
    # "/scratch/e1583535/llm/openseal-dpo/openseal_dpo_sailor2_stage1"
    # "/scratch/e1583535/llm/openseal-sft/openseal-multilingual-sailor2ds-stage1"
    # "/scratch/e1583535/llm/openseal-sft/openseal-multilingual-sailor2ds-stage2"
    # "/scratch/e1583535/llm/openseal-dpo/openseal_dpo_multilingual_sail2s1"
    # "/scratch/e1583535/llm/openseal-dpo/openseal_dpo_sail2s1_seaexams3"
    # "/scratch/e1583535/llm/openseal-dpo/openseal_dpo_sail2s1_seaexams3_cosmos"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-1b-sft"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-1b-sft-1epoch"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-1b-dpo-1epoch"
    # "/scratch/e1583535/llm/openseal-sft/openseal-SeaInstruct_stage2"
    # "/scratch/e1583535/llm/openseal-sft/openseal-sailor2-stage1-retrain"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-7b-sft-1epoch"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-7b-dpo-sft1epoch-fromTwinkle"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-7b-rlvr-gsm-grpo-fast"
    # "swiss-ai/Apertus-8B-2509"
    # "/scratch/e1583535/llm/openseal-sft/openseal-sft-quality_0.8_aya6lang_mcq"
    "/scratch/e1583535/llm/openseal-sft/openseal-sft-random_sailor_seainstruct_aya_mcq"
    # "aisingapore/Llama-SEA-LION-v3-8B"
)

# NOTE: space-separated here (no commas!)
# TASKS="xnli_en xnli_th xnli_vi xnli_zh xcopa_en xcopa_id xcopa_ta xcopa_th xcopa_vi xcopa_zh xcopa_7b-5shot_id_en xcopa_7b-5shot_ta_en xcopa_7b-5shot_th_en xcopa_7b-5shot_vi_en xcopa_7b-5shot_zh_en xcopa_google_id_en xcopa_google_ta_en xcopa_google_th_en xcopa_google_vi_en xcopa_google_zh_en xnli_7b_5shot_th_en xnli_7b_5shot_vi_en xnli_7b_5shot_zh_en xnli_google_th_en xnli_google_vi_en xnli_google_zh_en paws_en paws_zh"
TASKS="xnli_en xnli_th xnli_vi xnli_zh xcopa_en xcopa_id xcopa_ta xcopa_th xcopa_vi xcopa_zh paws_en paws_zh"
# TASKS="belebele_ind_Latn belebele_khm_Khmr belebele_lao_Laoo belebele_mya_Mymr belebele_zsm_Latn belebele_tam_Taml belebele_tha_Thai belebele_tgl_Latn belebele_vie_Latn belebele_sun_Latn belebele_ceb_Latn belebele_war_Latn belebele_zho_Hans belebele_ilo_Latn belebele_jav_Latn belebele_sun_Latn belebele_shn_Mymr"
# TASKS="xquad_en xquad_th xquad_vi xquad_zh"

TYPE="acl_rebuttal/xquad-260217"
BASE_LOG_DIR="/scratch/e1583535/multilingual-llm-project/logs/eval/lm-evaluation-harness/$TYPE"

mkdir -p "$BASE_LOG_DIR"

# Setup environment
export HF_HOME=/scratch/e1583535/cache
export HF_DATASETS_CACHE=/scratch/e1583535/cache/datasets

# Activate virtual environment
if [ -d "/hpctmp/e1583535/virtualenvs/lm-eval" ]; then
    source /hpctmp/e1583535/virtualenvs/lm-eval/bin/activate
fi

# Convert space-separated TASKS → comma-separated for lm_eval
TASKS_CSV=$(echo "$TASKS" | tr ' ' ',')

for MODEL in "${MODELS[@]}"; do
    BASE_NAME=$(basename "$MODEL")
    OUTPUT_PATH="/scratch/e1583535/results/lm_evaluation_harness/${TYPE}/$BASE_NAME"
    mkdir -p "$OUTPUT_PATH"

    echo "=========================================="
    echo "Starting evaluation for model: $MODEL"
    echo "BASE_NAME: $BASE_NAME"
    echo "OUTPUT_PATH: $OUTPUT_PATH"
    echo "Time: $(date)"
    echo "=========================================="

    lm_eval --model hf \
      --model_args "pretrained=$MODEL,parallelize=True" \
      --tasks "$TASKS_CSV" \
      --log_samples \
      --output_path "$OUTPUT_PATH" \
      --batch_size 8 \
      2>&1 | tee -a "$BASE_LOG_DIR/stdout.$BASE_NAME.log"

    if [ $? -eq 0 ]; then
        echo "✓ Successfully completed evaluation for: $MODEL"
    else
        echo "✗ Error during evaluation for: $MODEL"
    fi

    echo "Completed at $(date)"
    echo ""
done

echo "All model evaluations complete!"
