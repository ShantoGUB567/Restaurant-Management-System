#!/bin/bash

order_tracking() {
    clear
    echo "Order Tracking"
    echo "==================================="

    if [[ ! -f "Order.txt" ]]; then
        echo "No orders found."
        echo "Press any key to return to the main menu..."
        read -r anykey
        main_menu
        return
    fi

    while IFS=$'\t' read -r order_id customer_name customer_phone order_details order_time status; do
        order_timestamp=$(date -d "$order_time" +%s)
        current_timestamp=$(date +%s)
        elapsed_time=$(( (current_timestamp - order_timestamp) / 60 ))

        if [[ $elapsed_time -ge 4 ]]; then
            status="Delivered"
        elif [[ $elapsed_time -ge 1 ]]; then
            status="Cooking"
        else
            status="Pending"
        fi

        echo -e "Order ID: $order_id\tCustomer Name: $customer_name\tPhone: $customer_phone\tStatus: $status"
    done < Order.txt

    echo "==================================="
    echo "Press any key to return to the main menu..."
    read -r anykey
    main_menu
}

