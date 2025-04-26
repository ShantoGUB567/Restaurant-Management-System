#!/bin/bash

modify_order() {
    clear
    echo "Modify Order"
    echo "==================================="

    if [[ ! -f "Order.txt" ]]; then
        echo "No orders found."
        echo "Press any key to return to the main menu..."
        read -r anykey
        main_menu
        return
    fi

    read -p "Enter Order ID to modify: " order_id
    temp_file=$(mktemp)

    modified=false
    while IFS=$'\t' read -r id customer_name customer_phone order_details order_time status; do
        if [[ $id -eq $order_id ]]; then
            order_timestamp=$(date -d "$order_time" +%s)
            current_timestamp=$(date +%s)
            elapsed_time=$(( (current_timestamp - order_timestamp) / 60 ))

            if [[ $elapsed_time -ge 1 ]]; then
                echo "Order cannot be modified after 1 minute."
                echo -e "$id\t$customer_name\t$customer_phone\t$order_details\t$order_time\t$status" >> $temp_file
            else
                echo "Current Order Details:"
                echo -e "$order_details"
                order_details=""
                while true; do
                    read -p "Enter Item ID: " item_id

                    if [[ -z "${menu[$item_id]}" ]]; then
                        echo "Item with ID $item_id does not exist in the menu."
                    else
                        read -p "Enter Quantity: " quantity
                        item_info=(${menu[$item_id]})
                        item_name=${item_info[0]}
                        item_price=${item_info[1]}
                        item_quantity=${item_info[2]}

                        if (( quantity > item_quantity )); then
                            echo "Not enough quantity available. Available quantity: $item_quantity"
                        else
                            order_details+="$item_id\t$item_name\t$quantity\t$item_price\n"
                        fi
                    fi

                    read -p "Would you like to add another item? (y/n): " add_more
                    if [[ $add_more != "y" ]]; then
                        break
                    fi
                done
                modified=true
                echo -e "$id\t$customer_name\t$customer_phone\t$order_details\t$order_time\t$status" >> $temp_file
            fi
        else
            echo -e "$id\t$customer_name\t$customer_phone\t$order_details\t$order_time\t$status" >> $temp_file
        fi
    done < Order.txt

    mv $temp_file Order.txt

    if [[ $modified == true ]]; then
        echo "Order modified successfully."
    fi

    echo "Press any key to return to the main menu..."
    read -r anykey
    main_menu
}

