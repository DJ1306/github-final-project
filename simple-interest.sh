#!/bin/bash
# ------------------------------------------------------------------
# Script Name: simple-interest.sh
# Description: Calculates simple interest and total amount from user input.
# Formulae:
#   Simple Interest = (Principal * Rate * Time) / 100
#   Total Amount    = Principal + Simple Interest
# ------------------------------------------------------------------

# Function to check whether input is a valid non-negative number (integer or decimal)
is_number() {
    local val="$1"
    if [[ "$val" =~ ^[0-9]+([.][0-9]+)?$ ]] || [[ "$val" =~ ^[.][0-9]+$ ]]; then
        return 0
    fi
    return 1
}

echo "--------------------------------------------------"
echo "            Simple Interest Calculator            "
echo "--------------------------------------------------"

# 1. Prompt and validate Principal amount (must be positive > 0)
while true; do
    if ! read -r -p "Enter the principal amount: " principal; then
        echo ""
        exit 1
    fi
    principal="${principal//$'\r'/}"
    if is_number "$principal"; then
        is_pos=$(awk -v p="$principal" 'BEGIN { if (p > 0) print 1; else print 0 }')
        if [ "$is_pos" -eq 1 ]; then
            break
        else
            echo "Invalid input: Principal amount must be greater than 0."
        fi
    else
        echo "Invalid input: Please enter a positive number for principal."
    fi
done

# 2. Prompt and validate Annual Rate of Interest (must be non-negative >= 0)
while true; do
    if ! read -r -p "Enter the annual rate of interest (%): " rate; then
        echo ""
        exit 1
    fi
    rate="${rate//$'\r'/}"
    if is_number "$rate"; then
        is_non_neg=$(awk -v r="$rate" 'BEGIN { if (r >= 0) print 1; else print 0 }')
        if [ "$is_non_neg" -eq 1 ]; then
            break
        else
            echo "Invalid input: Rate of interest cannot be negative."
        fi
    else
        echo "Invalid input: Please enter a valid non-negative number for rate."
    fi
done

# 3. Prompt and validate Time period in years (must be positive > 0)
while true; do
    if ! read -r -p "Enter the time period in years: " time_period; then
        echo ""
        exit 1
    fi
    time_period="${time_period//$'\r'/}"
    if is_number "$time_period"; then
        is_pos=$(awk -v t="$time_period" 'BEGIN { if (t > 0) print 1; else print 0 }')
        if [ "$is_pos" -eq 1 ]; then
            break
        else
            echo "Invalid input: Time period must be greater than 0."
        fi
    else
        echo "Invalid input: Please enter a positive number for time period."
    fi
done

# 4. Calculate Simple Interest and Total Amount using awk
# Simple Interest = (Principal * Rate * Time) / 100
# Total Amount = Principal + Simple Interest
simple_interest=$(awk -v p="$principal" -v r="$rate" -v t="$time_period" 'BEGIN {
    si = (p * r * t) / 100;
    printf "%g", si;
}')

total_amount=$(awk -v p="$principal" -v si="$simple_interest" 'BEGIN {
    tot = p + si;
    printf "%g", tot;
}')

# 5. Display the calculated results clearly
echo ""
echo "--------------------------------------------------"
echo "                 Calculation Results              "
echo "--------------------------------------------------"
echo "Principal Amount : $principal"
echo "Annual Rate (%)  : $rate"
echo "Time (Years)     : $time_period"
echo "Simple Interest  : $simple_interest"
echo "Total Amount     : $total_amount"
echo "--------------------------------------------------"
