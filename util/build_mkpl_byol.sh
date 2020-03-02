#!/usr/bin/env bash

# Builds mkpl .zip for ORM. Uses local copy of existing TF.
# Replaces: variables.tf
# Adds: mkpl-schema.yaml, image_subscription.tf
# Output: $out_file

out_file="mkpl-byol.zip"
schema="mkpl-schema.yaml"
variables="mkpl-variables.tf"

echo "TEST cleanup"
rm -rf ./tmp_package
rm $out_file

echo "Creating tmp dir...."
mkdir ./tmp_package

echo "Copying .tf files to tmp dir...."
cp -v ../simple/*.tf ./tmp_package
echo "Copying script directory to tmp dir...."
cp -rv ../scripts ./tmp_package

echo "Removing provider.tf...."
rm ./tmp_package/provider.tf
echo "Removing variables.tf...."
rm ./tmp_package/variables.tf

echo "Adding $schema..."
cp $schema ./tmp_package
echo "Adding $variables..."
cp $variables ./tmp_package

#Keeping for future refactor. new location for image_subscription.tf 
#echo "Adding image_subscription.tf..."
#cp image_subscription.tf ./tmp_package

# Required path change since schema.yaml forces working directory to be
# root of .zip
sed -i '' "s:file(\"../scripts/worker.sh\"):file(\"./scripts/worker.sh\"):g" ./tmp_package/worker.tf
sed -i '' "s:file(\"../scripts/disks.sh\"):file(\"./scripts/disks.sh\"):g" ./tmp_package/worker.tf
sed -i '' "s:file(\"../scripts/metadata.sh\"):file(\"./scripts/metadata.sh\"):g" ./tmp_package/worker.tf

# Add latest git log entry
git log -n 1 > tmp_package/git.log

echo "Creating $out_file ...."
cd tmp_package
zip -r $out_file *
cd ..
mv tmp_package/$out_file ./

echo "Deleting tmp dir...."
rm -rf ./tmp_package
