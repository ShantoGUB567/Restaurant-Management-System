#!/bin/bash

# Load modules
source ./view_menu.sh
source ./authority.sh
source ./orders.sh
source ./order_tracking.sh
source ./modify_order.sh
source ./cancel_order.sh
source ./review.sh

#source ./menu.sh
#source ./billing.sh
#source ./reservations.sh
#source ./registration.sh

# Display the main menu
main_menu() {
    while true; do
        clear
        echo "==================================="
        echo "      Welcome to Foodie's Delight   "
        echo "==================================="
        echo "1. View Menu"
        echo "2. Make Order"
        echo "3. Order Tracking"
        echo "4. Modify Order"
        echo "5. Cancel Order"
        echo "6. Reviews"
        echo "7. Restaurant Authority (Manager)"
        echo "8. Help"
        echo "9. Exit"
        echo "==================================="
        read -p "Select an option: " option
        
        case $option in
            1) view_menu ;;
            2) make_order ;;
            3) order_tracking ;;
            4) modify_order ;;
            5) cancel_order ;;
            6) add_review ;;
            7) restaurant_authority ;;
            8) display_help ;;
            9) exit 0 ;;
            *) echo "Invalid option, please try again." ;;
        esac
    done
}

# Help function
display_help() {
    clear
echo "==================================="
    echo "      Help - Main Menu Options      "
    echo "==================================="
    echo "1. View Menu:"
    echo "   - View the available items on the menu."
    echo "2. Make Order:"
    echo "   - Place a new order for food items."
    echo "3. Order Tracking:"
    echo "   - Track the status of an existing order."
    echo "4. Modify Order:"
    echo "   - Modify items in an existing order."
    echo "5. Cancel Order:"
    echo "   - Cancel an existing order."
    echo "6. Reviews:"
    echo "   - Provide feedback and reviews about the service."
    echo "7. Restaurant Authority (Manager):"
    echo "   - Access administrative tasks for the restaurant."
    echo "8. Help:"
    echo "   - Get information about each menu option."
    echo "9. Exit:"
    echo "   - Quit the program."
    echo "==================================="
    read -p "Press any key to return to the main menu..." anykey
}

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
    echo "Press any key to return to the main menu..."
    read -r anykey
    main_menu.sh
}

# Execute main menu
main_menu

