// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/**
 * @title MarketplaceProducts
 * @dev A decentralized marketplace contract for creating and trading digital products/NFTs
 */
contract MarketplaceProducts {
    // Marketplace name
    string public storeName = "Marketplace Decentralized";
    
    // Counter for product IDs
    uint public productCount = 0;
    
    /**
     * @dev Product structure to store product details
     * @param id Unique product identifier
     * @param name Product name
     * @param description Detailed product description
     * @param image URL to product image
     * @param sold Flag indicating if product is sold
     * @param owner Current owner's address (payable)
     * @param price Product price in wei
     * @param category Product category
     */
    struct Product {
        uint id;
        string name;
        string description;
        string image;
        bool sold;
        address payable owner;
        uint price;
        string category;
    }

    /**
     * @dev Emitted when a new product is created
     */
    event ProductCreated(
        uint indexed id,
        string name,
        string image,
        bool sold,
        address indexed owner,
        uint price,
        string category
    );

    /**
     * @dev Emitted when a product is purchased
     */
    event ProductPurchased(
        uint indexed id,
        string name,
        bool sold,
        address indexed newOwner,
        uint price
    );

    // Mapping to store all products by their ID
    mapping(uint => Product) public products;

    /**
     * @dev Creates a new product listing
     * @param name Product name (min 4 chars)
     * @param description Product description (min 11 chars)
     * @param image URL to product image (min 11 chars)
     * @param price Product price in wei (must be > 0)
     * @param category Product category (min 2 chars)
     */
    function createProduct(
        string memory name,
        string memory description,
        string memory image,
        uint price,
        string memory category
    ) public {
        // Validate input parameters
        require(price > 0, "Price must be greater than 0");
        require(bytes(name).length >= 4, "Name must be at least 4 characters");
        require(bytes(description).length >= 11, "Description must be at least 11 characters");
        require(bytes(image).length >= 11, "Image URL must be at least 11 characters");
        require(bytes(category).length >= 2, "Category must be at least 2 characters");

        // Increment product counter
        productCount++;
        
        // Create and store new product
        products[productCount] = Product(
            productCount,
            name,
            description,
            image,
            false,
            payable(msg.sender),
            price,
            category
        );

        // Emit creation event
        emit ProductCreated(
            productCount,
            name,
            image,
            false,
            msg.sender,
            price,
            category
        );
    }

    /**
     * @dev Purchases an existing product
     * @param id ID of the product to purchase
     */
    function buyProduct(uint id) public payable {
        Product storage product = products[id];
        
        // Validate purchase conditions
        require(!product.sold, "Product already sold");
        require(product.owner != msg.sender, "Cannot buy your own product");
        require(msg.value >= product.price, "Insufficient payment amount");

        // Transfer funds to seller
        product.owner.transfer(msg.value);

        // Update product ownership and status
        product.owner = payable(msg.sender);
        product.sold = true;

        // Emit purchase event
        emit ProductPurchased(
            id,
            product.name,
            true,
            msg.sender,
            product.price
        );
    }
}