#!/bin/bash
echo "=== CLOUD ARCHITECT AUTOMATED NETWORK AUDIT ==="
echo "Date: $(date)"
echo ""
echo "[LAYER 4] Active Listening TCP/UDP Ports:"
ss -tuln | head -n 10
echo ""
echo "[LAYER 5] Active Established sessions:"
ss -atp | grep "ESTAB" | head -n 5

