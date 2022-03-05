FULL_LABEL_PATH="/workspace/datasets/categories"
LABEL_FILE_NAME="output_shuffled.fasttext"
NUM_RECS=20000

echo $FULL_LABEL_PATH

cat "${FULL_LABEL_PATH}/${LABEL_FILE_NAME}" | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" > "${FULL_LABEL_PATH}/pre_${LABEL_FILE_NAME}"

# Split labeled data into training and test.
head -n $NUM_RECS "${FULL_LABEL_PATH}/pre_${LABEL_FILE_NAME}" > product_categories.train
tail -n $NUM_RECS "${FULL_LABEL_PATH}/pre_${LABEL_FILE_NAME}" > product_categories.test

# Train model
~/fastText-0.9.2/fasttext supervised -input product_categories.train -output model_categories -epoch 25 -lr 1.0 -wordNgrams 2

# Test model for P@1 and R@1
~/fastText-0.9.2/fasttext test model_categories.bin product_categories.test

# Test model for P@5 and R@5
~/fastText-0.9.2/fasttext test model_categories.bin product_categories.test 5

# Test model for P@10 and R@10
~/fastText-0.9.2/fasttext test model_categories.bin product_categories.test 10








