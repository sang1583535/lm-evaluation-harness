source /hpctmp/e1583535/virtualenvs/lm-eval/bin/activate

echo "Starting evaluating at \$(date)"
echo "Running on host: \$(hostname)"
echo "GPU info:"
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader,nounits || echo "No GPU detected"

export HF_HOME=/scratch/e1583535/cache 
export HF_DATASETS_CACHE=/scratch/e1583535/cache/datasets

accelerate launch --multi_gpu --num_processes 8 \
-m lm_eval --model hf \
  --model_args pretrained=sail/Sailor2-8B,parallelize=True \
  --tasks xquad_en,xquad_th,xquad_vi,xquad_zh \
  --log_samples \
  --output_path /scratch/e1583535/results/lm_evaluation_harness/xquad-260217/Sailor2-8B_2 \
  --verbosity DEBUG \
  --batch_size 128

EOF
