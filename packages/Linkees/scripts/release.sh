#!/bin/sh
package_name='linktree'

npm run clean
npm run build

current_version=$(node -p "require('./package').version")
ICONS_DIR=$(pwd)

printf "Next version for $package_name (current is $current_version)? "
read next_version

if ! [[ $next_version =~ ^[0-9]+\.[0-9]+\.[0-9](-.+)? ]]; then
  echo "Version must be a valid semver string, e.g. 1.0.2 or 2.3.0-beta.1"
  exit 1
fi

if [[ $current_version = $next_version ]]; then
  echo "Republishing same version. Deleting the older version"
  echo "Successfully deleted older version"
fi

npm version "$next_version" --allow-same-version
cp package.json README.md ./dist
git add . 
git commit -m "upgrades $package_name to ${next_version}"

echo "Publishing $package_name ${next_version}"

cd dist
npm publish
echo "$package_name ${next_version} is successfully published."


