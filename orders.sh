#!/bin/bash

declare -A menu

load_menu() {
    if [[ -f "menu.txt" ]]; then
        while IFS=$'\t' read -r id name price quantity; do
            menu["$id"]="$name $price $quantity"
        done < menu.txt
    fi
}

view_menu() {
    clear
    echo "View Menu"
    echo "==================================="
    echo -e "Item ID\tItem Name\tPrice\tQuantity"
    echo "-----------------------------------"
    
    load_menu
    
    if [[ ${#menu[@]} -eq 0 ]]; then
        echo "No items in the menu."
    else
        for id in "${!menu[@]}"; do
            item_info=(${menu[$id]})
            name=${item_info[0]}
            price=${item_info[1]}
            quantity=${item_info[2]}
            echo -e "$id\t$name\t$price\t$quantity"
        done
    fi
    
    echo "==================================="
    #echo "Press any key to return to the main menu..."
    #read -r anykey
    #main_menu.sh
}

#declare -A menu

load_menu() {
    if [[ -f "menu.txt" ]]; then
        while IFS=$'\t' read -r id name price quantity; do
            menu["$id"]="$name $price $quantity"
        done < menu.txt
    fi
}

save_order() {
    order_id=$(( $(wc -l < Order.txt) + 1 ))
    echo -e "$order_id\t$customer_name\t$customer_phone\t$order_details\t$date_time\tPending" >> Order.txt
}

make_order() {
    clear
    view_menu

    order_details=""
    total_bill=0

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
                total_bill=$((total_bill + item_price * quantity))
                menu["$item_id"]="$item_name $item_price $(( item_quantity - quantity ))"
            fi
        fi

        read -p "Would you like to add another item? (y/n): " add_more
        if [[ $add_more != "y" ]]; then
            break
        fi
    done

    read -p "Enter Customer Name: " customer_name
    read -p "Enter Customer Phone: " customer_phone
    date_time=$(date "+%Y-%m-%d %H:%M:%S")

    save_menu
    save_order

    echo "Order placed successfully! Order ID: $order_id"
    echo "Customer Name: $customer_name"
    echo "Order Details:"
    echo -e "$order_details"
    echo "Total Bill: $$total_bill"

    echo "Press any key to return to the main menu..."
    read -r anykey
    main_menu
}

save_menu() {
    > menu.txt
    for id in "${!menu[@]}"; do
        item_info=(${menu[$id]})
        name=${item_info[0]}
        price=${item_info[1]}
        quantity=${item_info[2]}
        echo -e "$id\t$name\t$price\t$quantity" >> menu.txt
    done
}

