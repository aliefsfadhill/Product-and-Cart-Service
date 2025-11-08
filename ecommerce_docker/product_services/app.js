const express = require('express');
const app = express();

// Dummy data produk
const products = [
    { id: 1, name: 'iPhone 17 Pro Max', price: 100, Description: 'This is iPhone 17 Pro Max' },
    { id: 2, name: 'Rice Cooker Miyako', price: 50, Description: 'This is Rice Cooker Miyako' },
    { id: 3, name: 'Laptop ROG', price: 200, Description: 'This is Laptop ROG' },
];

// Endpoint untuk menampilkan daftar produk
app.get('/products', (req, res) => {
    res.json(products);
});

// Endpoint untuk mendapatkan detail produk berdasarkan ID
app.get('/products/:id', (req, res) => {
    const productId = parseInt(req.params.id);
    const product = products.find(p => p.id === productId);
    if (product) {
        res.json(product);
    } else {
        res.status(404).json({ error: 'Product not found' });
    }
});

// Menjalankan server pada port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Product service is running on port ${PORT}`);
});

// Cara kedua