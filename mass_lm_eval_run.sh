#!/bin/bash

MODELS=(
    # "/scratch/e1583535/llm/nus-olmo/mixed-10B"
    # "/scratch/e1583535/llm/nus-olmo/para-first-10B"
    # "/scratch/e1583535/llm/nus-olmo/para-last-10B"
    # "/scratch/e1583535/llm/nus-olmo/multi-uniform-n10B-SEA-7.5_replay-2.5-checkpoints/step4770-unsharded-hf-multi-uniform"
    # "/scratch/e1583535/llm/nus-olmo/multilingual-n10B-7.5-replay-2.5-checkpoints/step4770-unsharded-hf-multilingual"
    # "/scratch/e1583535/llm/nus-olmo/para-only-10B"
    # "/scratch/e1583535/llm/nus-olmo/para-only-34B8"
    "/scratch/e1583535/llm/nus-olmo/multilingual-uniform-7B_n34.8-26_replay-8.7-checkpoints/step8290-unsharded-hf-multilingual-uniform-34.7B"
    "/scratch/e1583535/llm/nus-olmo/multilingual-7B_n34.8-26_replay-8.7-checkpoints/step8290-unsharded-hf-multilingual-7B-34.7B"
    # "/scratch/e1583535/llm/nus-olmo/para-only-7B-34B-checkpoints/step8290-unsharded-hf-para-only-7B-34.7B"
    # "SeaLLMs/SeaLLMs-v3-1.5B"
    # "sail/Sailor2-L-1B"
    # "SeaLLMs/SeaLLMs-v3-7B"
    # "sail/Sailor2-8B"
    # "aisingapore/Llama-SEA-LION-v3.5-8B-R"
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
    # "allenai/OLMo-2-0425-1B"
    # "allenai/OLMo-2-0425-1B-SFT"
    # "allenai/OLMo-2-0425-1B-DPO"
    # "allenai/OLMo-2-0425-1B-Instruct"
    # "allenai/OLMo-2-1124-7B"
    # "allenai/OLMo-2-1124-7B-Instruct"
    # "/scratch/e1583535/llm/openseal-sft/openseal-seainstruct"
    # "allenai/OLMo-2-0325-32B"
    # "allenai/OLMo-2-0325-32B-Instruct"
    # "Qwen/Qwen2.5-7B"
    # "Qwen/Qwen2.5-7B-Instruct"
    # "Qwen/Qwen2.5-32B"
    # "Qwen/Qwen2.5-32B-Instruct"
    # "meta-llama/Llama-3.1-8B"
    # "meta-llama/Llama-3.1-8B-Instruct"
    # "meta-llama/Llama-3.1-70B"
    # "meta-llama/Llama-3.1-70B-Instruct"
    # "/scratch/e1583535/llm/openseal-sft/openseal-SeaInstruct_stage1"
    # "/scratch/e1583535/llm/openseal-sft/openseal-SeaInstruct_stage2"
    # "/scratch/e1583535/llm/reproduce-olmo2/olmo2-1b-sft"
    # "meta-llama/Llama-3.1-8B-Instruct"
    # "andrewivan123/culfit_sft_only_merged_add_aya"
    # "dragoox/culfit_sft_randomGt_add_aya"
    # "swiss-ai/Apertus-8B-2509"
    # "aisingapore/Llama-SEA-LION-v3-8B-IT"
    # "aisingapore/Llama-SEA-LION-v3-8B"
)

# NOTE: space-separated here (no commas!)
# TASKS="xnli_en xnli_th xnli_vi xnli_zh xcopa_en xcopa_id xcopa_ta xcopa_th xcopa_vi xcopa_zh xcopa_7b-5shot_id_en xcopa_7b-5shot_ta_en xcopa_7b-5shot_th_en xcopa_7b-5shot_vi_en xcopa_7b-5shot_zh_en xcopa_google_id_en xcopa_google_ta_en xcopa_google_th_en xcopa_google_vi_en xcopa_google_zh_en xnli_7b_5shot_th_en xnli_7b_5shot_vi_en xnli_7b_5shot_zh_en xnli_google_th_en xnli_google_vi_en xnli_google_zh_en paws_en paws_zh"
# TASKS="xnli_en xnli_th xnli_vi xnli_zh xcopa_en xcopa_id xcopa_ta xcopa_th xcopa_vi xcopa_zh paws_en paws_zh xstorycloze_en xstorycloze_id xstorycloze_my xstorycloze_zh xwinograd_en xwinograd_zh xquad_en xquad_th xquad_vi xquad_zh kalahi_tl copal_id_standard copal_id_colloquial"
TASKS="belebele_ind_Latn belebele_khm_Khmr belebele_lao_Laoo belebele_mya_Mymr belebele_zsm_Latn belebele_tam_Taml belebele_tha_Thai belebele_tgl_Latn belebele_vie_Latn belebele_sun_Latn belebele_ceb_Latn belebele_war_Latn belebele_zho_Hans belebele_ilo_Latn belebele_jav_Latn belebele_shn_Mymr"

TYPE="ood/belebele-260518"
BASE_LOG_DIR="/scratch/e1583535/multilingual-llm-project/logs/eval/lm-evaluation-harness/$TYPE"

mkdir -p "$BASE_LOG_DIR"

for MODEL in "${MODELS[@]}"; do
    BASE_NAME=$(basename "$MODEL")
    OUTPUT_PATH="/scratch/e1583535/results/lm_evaluation_harness/${TYPE}/$BASE_NAME"
    mkdir -p "$OUTPUT_PATH"

    qsub -v MODEL="$MODEL",TASKS="$TASKS",OUTPUT_PATH="$OUTPUT_PATH",BASE_LOG_DIR="$BASE_LOG_DIR" mass_lm_eval_run.pbs

    echo "Submitted job for model: $MODEL"
    sleep 2
done
