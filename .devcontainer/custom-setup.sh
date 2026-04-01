
# This file lets you to further initialize the docker.
# It is ran as designer user as the last script

echo "=========== START CUSTOM SETUP =============="

# Python package:
# pip3 install --no-cache-dir --break-system-packages \
#   package_1 \
#   package_2

# Reset the rights
find /design -type f -exec chmod 644 {} \;
find /design -type d -exec chmod 755 {} \;

echo "============ END CUSTOM SETUP ==============="