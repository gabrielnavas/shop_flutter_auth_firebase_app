# Shop Flutter App

## Before all
- Create a firebase project.
- Add the URI to the const String api in the lib/constants/api.dart file.
- [ WARNING ]Change rules on project to:
```json
{
  "rules": {
    "orders": {
      "$uid": {
        ".write": "$uid === auth.uid",
        ".read": "$uid === auth.uid",
      },
    },
    "userProductFavorites": {
    	"$uid": {
      	".write": "$uid === auth.uid",
        ".read": "$uid === auth.uid",
      },
    },
    "products": {
        ".write": "auth != null",
        ".read": "auth != null",
    }
  }
}
```
- In Auth page, activate the E-mail/password providers

# Preview
- Implements register, login with token and logout by firebase.
- Small shop project with a Firebase backend.
- With state manager and data persistence on Firebase.

<br>

## Screens

### Login 
![Login](docs/screens/login_screen.png "Login")

### Register 
![Register](docs/screens/register.png "Register")

### Product Overview
![Product Overview](docs/screens/products_overview.png "Product Overview")

### Product Overview with favorite and cart added
![Product Overview with favorite and cart added](docs/screens/product_overview_with_favorite_and_cart_added.png "Product Overview with favorite and cart added")

### Product Overview with favorite marked
![Product Overview with favorite marked](docs/screens/favorite_filter.png "Product Overview with favorite marked")

### Product Manager
![Product Manager](docs/screens/product_manager.png "Product Manager")

### Add Product
![Add Product](docs/screens/add_product.png "Add Product")


### Remove Product
![Remove Product](docs/screens/remove_product_shield.png "Remove Product")


### Update Product
![Update Product](docs/screens/update_product.png "Update Product")

### Orders
![Orders](docs/screens/orders.png "Orders")


### Drawer Menu
![Drawer Menu](docs/screens/drawer.png "Drawer Menu")

### Cart 
![Cart](docs/screens/cart.png "Cart")


