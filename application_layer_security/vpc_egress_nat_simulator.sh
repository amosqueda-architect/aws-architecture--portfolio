#!/bin/bash
set -e

PUB_NS="vpc_pub_zone"
PRIV_NS="vpc_priv_zone"
V_PUB="vpc_pub_gw"
V_PRIV="veth_priv_app"

sudo ip netns del "${PUB_NS}" 2>/dev/null || true
sudo ip netns del "${PRIV_NS}" 2>/dev/null || true

sudo ip netns add "${PUB_NS}"
sudo ip netns add "${PRIV_NS}"

sudo ip link add "${V_PUB}" type veth peer name "${V_PRIV}"
sudo ip link set "${V_PUB}" netns "${PUB_NS}"
sudo ip link set "${V_PRIV}" netns "${PRIV_NS}"

sudo ip netns exec "${PUB_NS}" ip addr add 10.0.1.1/24 dev "${V_PUB}"
sudo ip netns exec "${PUB_NS}" ip link set "${V_PUB}" up
sudo ip netns exec "${PRIV_NS}" ip addr add 10.0.2.1/24 dev "${V_PRIV}"
sudo ip netns exec "${PRIV_NS}" ip link set "${V_PRIV}" up

if sudo ip netns exec "${PRIV_NS}" ping -c 1 -W 1 192.0.2.1 >/dev/null 2>&1; then
echo "AUDIT FAILURE: Private tier exposed!"
exit 1

else
echo "SUCCESS: Architectural boundary confirmed."
fi

sudo ip netns del "${PUB_NS}"
sudo ip netns del "${PRIV_NS}"
