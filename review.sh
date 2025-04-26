#!/bin/bash

reviews_file="reviews.txt"

display_reviews() {
    if [[ -f "$reviews_file" ]]; then
        echo "Stored Reviews:"
        cat "$reviews_file"
    else
        echo "No reviews found."
    fi
}

add_review() {
    clear
    display_reviews
    echo "-----------------------------------"
    #echo "-----------------------------------"
    read -p "Do you want to give a review? (y/n): " answer
    if [[ $answer == "n" ]]; then
        echo "-----------------------------------"
        echo "Press any key to return to the main menu..."
        read -r anykey
        main_menu
    fi    
    
    read -p "Enter Customer Name: " customer_name
    read -p "Enter Item Name: " item_name
    read -p "Enter Rating (1-5): " rating
    read -p "Enter Comment: " comment

    # Validate rating (must be between 1 and 5)
    if [[ $rating -lt 1 || $rating -gt 5 ]]; then
        echo "Rating must be between 1 and 5."
        return
    fi

    # Append review to file
    echo "Customer: $customer_name" >> "$reviews_file"
    echo "Item: $item_name" >> "$reviews_file"
    echo "Rating: $rating" >> "$reviews_file"
    echo "Comment: $comment" >> "$reviews_file"
    echo "-----------------------------------" >> "$reviews_file"

    echo "Review added successfully!"
    echo "Thanks you for you review!"
    
    echo ""
    echo "Press any key to return to the main menu..."
    read -r anykey
    main_menu
}

