source /hpctmp/e1583535/virtualenvs/lm-eval/bin/activate

echo "Starting evaluating at $(date)"
echo "Running on host: $(hostname)"
echo "GPU info:"
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader,nounits || echo "No GPU detected"

export HF_HOME=/scratch/e1583535/cache 
export HF_DATASETS_CACHE=/scratch/e1583535/cache/datasets

lm_eval --model hf \
  --model_args pretrained=/scratch/e1583535/llm/nus-olmo/para-replay-n10B,parallelize=True \
  --tasks aisg_lindsea_pragmatics \
  --log_samples \
  --output_path /scratch/e1583535/results/lm_evaluation_harness/aisg-260305/para-replay-n10B \
  --batch_size 8 \
  --limit 2 