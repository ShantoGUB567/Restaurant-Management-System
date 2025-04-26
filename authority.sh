#!/bin/bash

manager_username="shanto567"
manager_password="popo221"

restaurant_authority() {
    clear
    read -p "Enter manager username: " username
    read -sp "Enter manager password: " password
    echo
    if [[ $username == $manager_username && $password == $manager_password ]]; then
        manager_panel
    else
        echo "Invalid username or password. Access denied."
        read -p "Press any key to return to the main menu..." anykey
    fi
}

manager_panel() {
    while true; do
        clear
        echo "==================================="
        echo "     Manager Panel"
        echo "==================================="
        echo "1. Add Items"
        echo "2. View Menu"
        echo "3. Modify Item"
        echo "4. Delete Item"
        echo "5. View Order Record"
        echo "6. Back to Main Menu"
        echo "==================================="
        read -p "Select an option: " option

        case $option in
            1) add_items ;;
            2) view_menu ;;
            3) modify_item ;;
            4) delete_item ;;
            5) view_order_record ;;
            6) main_menu ;;
            *) echo "Invalid option, please try again." ;;
        esac
    done
}

declare -A menu

load_menu() {
    if [[ -f "menu.txt" ]]; then
        while IFS=$'\t' read -r id name price quantity; do
            menu["$id"]="$name $price $quantity"
        done < menu.txt
    fi
}

save_menu() {
    > menu.txt
    for id in "${!menu[@]}"; do
        name=$(echo "${menu[$id]}" | awk '{print $1}')
        price=$(echo "${menu[$id]}" | awk '{print $2}')
        quantity=$(echo "${menu[$id]}" | awk '{print $3}')
        echo -e "$id\t$name\t$price\t$quantity" >> menu.txt
    done
}

add_items() {
    clear
    echo "Add Items to Menu"
    echo "==================================="

    load_menu
    
    while true; do
        read -p "Enter Item ID: " item_id
        read -p "Enter Item Name: " item_name
        read -p "Enter Price: " price
        read -p "Enter Quantity: " quantity

        if [[ -n "${menu[$item_id]}" ]]; then
            echo "Item with ID $item_id already exists in the menu."
        else
            menu["$item_id"]="$item_name $price $quantity"
            echo "Item added successfully."
        fi

        read -p "Would you like to add another item? (y/n): " add_more
        if [[ $add_more != "y" ]]; then
            break
        fi
    done
    
    save_menu
    
    echo "Press any key to return to the Manager Panel..."
    read -r anykey
    manager_panel
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
            name=$(echo "${menu[$id]}" | awk '{print $1}')
            price=$(echo "${menu[$id]}" | awk '{print $2}')
            quantity=$(echo "${menu[$id]}" | awk '{print $3}')
            echo -e "$id\t$name\t$price\t$quantity"
        done
    fi
    
    echo "==================================="
    echo "Press any key to return to the Manager Panel..."
    read -r anykey
    manager_panel
}

modify_item() {
    clear
    echo "Modify Item"
    echo "==================================="
    echo -e "Item ID\tItem Name\tPrice\tQuantity"
    echo "-----------------------------------"
    
    load_menu
    
    if [[ ${#menu[@]} -eq 0 ]]; then
        echo "No items in the menu."
    else
        for id in "${!menu[@]}"; do
            name=$(echo "${menu[$id]}" | awk '{print $1}')
            price=$(echo "${menu[$id]}" | awk '{print $2}')
            quantity=$(echo "${menu[$id]}" | awk '{print $3}')
            echo -e "$id\t$name\t$price\t$quantity"
        done
    fi
    
    echo "==================================="
    
    load_menu
    
    read -p "Enter Item ID to modify: " item_id

    if [[ -n "${menu[$item_id]}" ]]; then
        read -p "Enter new price: " new_price
        read -p "Enter new quantity: " new_quantity
        name=$(echo "${menu[$item_id]}" | awk '{print $1}')
        menu["$item_id"]="$name $new_price $new_quantity"
        save_menu
        echo "Item modified successfully."
    else
        echo "Item with ID $item_id does not exist."
    fi
    
    echo "Press any key to return to the Manager Panel..."
    read -r anykey
    manager_panel
}

delete_item() {
    clear
    echo "Delete Item"
    echo "==================================="
    echo -e "Item ID\tItem Name\tPrice\tQuantity"
    echo "-----------------------------------"
    
    load_menu
    
    if [[ ${#menu[@]} -eq 0 ]]; then
        echo "No items in the menu."
    else
        for id in "${!menu[@]}"; do
            name=$(echo "${menu[$id]}" | awk '{print $1}')
            price=$(echo "${menu[$id]}" | awk '{print $2}')
            quantity=$(echo "${menu[$id]}" | awk '{print $3}')
            echo -e "$id\t$name\t$price\t$quantity"
        done
    fi
    
    echo "==================================="
    
    load_menu
    
    read -p "Enter Item ID to delete: " item_id

    if [[ -n "${menu[$item_id]}" ]]; then
        unset menu["$item_id"]
        save_menu
        echo "Item deleted successfully."
    else
        echo "Item with ID $item_id does not exist."
    fi
    
    echo "Press any key to return to the Manager Panel..."
    read -r anykey
    manager_panel
}

view_order_record() {
    clear
    echo "View Order Record"
    echo "==================================="
    
    if [[ ! -f "Order.txt" ]]; then
        echo "No orders found."
    else
        column -t -s $'\t' Order.txt
    fi
    
    echo "==================================="
    echo "Press any key to return to the Manager Panel..."
    read -r anykey
    manager_panel
}

