#!/bin/bash

cancel_order() {
    clear
    echo "Cancel Order"
    echo "==================================="

    if [[ ! -f "Order.txt" ]]; then
        echo "No orders found."
        echo "Press any key to return to the main menu..."
        read -r anykey
        main_menu
        return
    fi

    read -p "Enter Order ID to cancel: " order_id
    temp_file=$(mktemp)

    canceled=false
    while IFS=$'\t' read -r id customer_name customer_phone order_details order_time status; do
        if [[ $id -eq $order_id ]]; then
            order_timestamp=$(date -d "$order_time" +%s)
            current_timestamp=$(date +%s)
            elapsed_time=$(( (current_timestamp - order_timestamp) / 60 ))

            if [[ $elapsed_time -ge 1 ]]; then
                echo "Order cannot be canceled after 1 minute."
                echo -e "$id\t$customer_name\t$customer_phone\t$order_details\t$order_time\t$status" >> $temp_file
            else
                canceled=true
            fi
        else
            echo -e "$id\t$customer_name\t$customer_phone\t$order_details\t$order_time\t$status" >> $temp_file
        fi
    done < Order.txt

    mv $temp_file Order.txt

    if [[ $canceled == true ]]; then
        echo "Order canceled successfully."
    fi

    echo "Press any key to return to the main menu..."
    read -r anykey
    main_menu
}

