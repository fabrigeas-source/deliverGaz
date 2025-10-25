import request from 'supertest';
import express from 'express';
import cartRouter from './cart.route';

// Mock Express app setup
const app = express();
app.use(express.json());
app.use('/api/cart', cartRouter);

describe('Cart Routes', () => {
  describe('GET /api/cart', () => {
    it('should retrieve user cart successfully', async () => {
      const response = await request(app)
        .get('/api/cart')
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('message', 'Cart retrieved successfully');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data).toHaveProperty('user');
      expect(response.body.data).toHaveProperty('items');
      expect(response.body.data).toHaveProperty('itemCount');
      expect(response.body.data).toHaveProperty('total');
      expect(response.body.data).toHaveProperty('currency');
      expect(Array.isArray(response.body.data.items)).toBe(true);
      expect(typeof response.body.data.total).toBe('number');
      expect(typeof response.body.data.itemCount).toBe('number');
    });

    it('should return valid cart structure', async () => {
      const response = await request(app)
        .get('/api/cart')
        .expect(200);

      const { data } = response.body;
      expect(data).toMatchObject({
        id: expect.any(String),
        user: expect.any(String),
        items: expect.any(Array),
        itemCount: expect.any(Number),
        total: expect.any(Number),
        currency: expect.any(String),
        lastUpdated: expect.any(String),
        createdAt: expect.any(String),
        updatedAt: expect.any(String)
      });

      // Validate cart items structure if present
      if (data.items.length > 0) {
        data.items.forEach((item: any) => {
          expect(item).toMatchObject({
            product: expect.any(String),
            quantity: expect.any(Number),
            price: expect.any(Number),
            subtotal: expect.any(Number),
            addedAt: expect.any(String)
          });
          expect(item.quantity).toBeGreaterThan(0);
          expect(item.price).toBeGreaterThanOrEqual(0);
          expect(item.subtotal).toBeGreaterThanOrEqual(0);
        });
      }
    });

    it('should handle different HTTP methods correctly', async () => {
      // POST should not be allowed on base cart endpoint
      await request(app)
        .post('/api/cart')
        .expect(404);

      // PUT should not be allowed on base cart endpoint
      await request(app)
        .put('/api/cart')
        .expect(404);

      // DELETE should not be allowed on base cart endpoint
      await request(app)
        .delete('/api/cart')
        .expect(404);
    });
  });

  describe('POST /api/cart/add', () => {
    it('should add item to cart successfully with valid data', async () => {
      const cartItem = {
        productId: '60d5ecb74f1a6b2f8c8b4567',
        quantity: 2
      };

      const response = await request(app)
        .post('/api/cart/add')
        .send(cartItem)
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('message', 'Item added to cart successfully');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('items');
      expect(response.body.data.items).toHaveLength(1);
      expect(response.body.data.items[0]).toMatchObject({
        product: cartItem.productId,
        quantity: cartItem.quantity,
        price: expect.any(Number),
        subtotal: expect.any(Number)
      });
    });

    it('should validate required fields', async () => {
      // Missing productId
      const response1 = await request(app)
        .post('/api/cart/add')
        .send({ quantity: 2 })
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response1.body).toHaveProperty('success', false);
      expect(response1.body).toHaveProperty('message', 'Product ID and quantity are required');
      expect(response1.body).toHaveProperty('errors');
      expect(Array.isArray(response1.body.errors)).toBe(true);

      // Missing quantity
      const response2 = await request(app)
        .post('/api/cart/add')
        .send({ productId: '60d5ecb74f1a6b2f8c8b4567' })
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response2.body).toHaveProperty('success', false);
      expect(response2.body).toHaveProperty('errors');

      // Missing both fields
      const response3 = await request(app)
        .post('/api/cart/add')
        .send({})
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response3.body).toHaveProperty('success', false);
      expect(response3.body).toHaveProperty('errors');
    });

    it('should validate quantity constraints', async () => {
      // Zero quantity
      const response1 = await request(app)
        .post('/api/cart/add')
        .send({
          productId: '60d5ecb74f1a6b2f8c8b4567',
          quantity: 0
        })
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response1.body).toHaveProperty('success', false);
      expect(response1.body).toHaveProperty('message', 'Quantity must be at least 1');

      // Negative quantity
      const response2 = await request(app)
        .post('/api/cart/add')
        .send({
          productId: '60d5ecb74f1a6b2f8c8b4567',
          quantity: -1
        })
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response2.body).toHaveProperty('success', false);
      expect(response2.body).toHaveProperty('message', 'Quantity must be at least 1');
    });

    it('should handle different data types correctly', async () => {
      // String quantity that can be converted to number
      const response1 = await request(app)
        .post('/api/cart/add')
        .send({
          productId: '60d5ecb74f1a6b2f8c8b4567',
          quantity: '2'
        })
        .expect('Content-Type', /json/);

      // Should handle string quantities gracefully
      expect([200, 400]).toContain(response1.status);

      // Non-numeric quantity
      const response2 = await request(app)
        .post('/api/cart/add')
        .send({
          productId: '60d5ecb74f1a6b2f8c8b4567',
          quantity: 'invalid'
        })
        .expect('Content-Type', /json/);

      expect([400, 500]).toContain(response2.status);
    });

    it('should handle malformed JSON', async () => {
      const response = await request(app)
        .post('/api/cart/add')
        .set('Content-Type', 'application/json')
        .send('{"productId": "60d5ecb74f1a6b2f8c8b4567", "quantity": 2,}') // Invalid JSON with trailing comma
        .expect(400);

      expect(response.body).toBeDefined();
    });

    it('should validate Content-Type header', async () => {
      const response = await request(app)
        .post('/api/cart/add')
        .set('Content-Type', 'text/plain')
        .send('productId=60d5ecb74f1a6b2f8c8b4567&quantity=2')
        .expect('Content-Type', /json/);

      // Should handle different content types gracefully
      expect([200, 400, 415]).toContain(response.status);
    });
  });

  describe('PUT /api/cart/update/:productId', () => {
    it('should update cart item quantity successfully', async () => {
      const productId = '60d5ecb74f1a6b2f8c8b4567';
      const updateData = { quantity: 5 };

      const response = await request(app)
        .put(`/api/cart/update/${productId}`)
        .send(updateData)
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('message', 'Cart item updated successfully');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('items');
      expect(response.body.data.items[0]).toMatchObject({
        product: productId,
        quantity: updateData.quantity
      });
    });

    it('should validate quantity for updates', async () => {
      const productId = '60d5ecb74f1a6b2f8c8b4567';

      // Zero quantity
      const response1 = await request(app)
        .put(`/api/cart/update/${productId}`)
        .send({ quantity: 0 })
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response1.body).toHaveProperty('success', false);
      expect(response1.body).toHaveProperty('message', 'Valid quantity is required');

      // Negative quantity
      const response2 = await request(app)
        .put(`/api/cart/update/${productId}`)
        .send({ quantity: -1 })
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response2.body).toHaveProperty('success', false);

      // Missing quantity
      const response3 = await request(app)
        .put(`/api/cart/update/${productId}`)
        .send({})
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response3.body).toHaveProperty('success', false);
    });

    it('should handle different productId formats', async () => {
      const testCases = [
        'validProductId123',
        '60d5ecb74f1a6b2f8c8b4567',
        'product-with-dashes',
        'product_with_underscores',
        '123',
        'a'
      ];

      for (const productId of testCases) {
        const response = await request(app)
          .put(`/api/cart/update/${productId}`)
          .send({ quantity: 3 })
          .expect('Content-Type', /json/);

        expect([200, 400, 404]).toContain(response.status);
        expect(response.body).toHaveProperty('success');
      }
    });

    it('should handle special characters in productId', async () => {
      const specialIds = [
        encodeURIComponent('product with spaces'),
        encodeURIComponent('product@special#chars'),
        encodeURIComponent('产品ID'), // Chinese characters
        encodeURIComponent('المنتج') // Arabic characters
      ];

      for (const productId of specialIds) {
        const response = await request(app)
          .put(`/api/cart/update/${productId}`)
          .send({ quantity: 2 })
          .expect('Content-Type', /json/);

        expect([200, 400, 404]).toContain(response.status);
      }
    });
  });

  describe('DELETE /api/cart/remove/:productId', () => {
    it('should remove item from cart successfully', async () => {
      const productId = '60d5ecb74f1a6b2f8c8b4567';

      const response = await request(app)
        .delete(`/api/cart/remove/${productId}`)
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('message', 'Item removed from cart successfully');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('items');
      expect(response.body.data).toHaveProperty('itemCount');
      expect(response.body.data).toHaveProperty('total');
    });

    it('should handle removal of different productId formats', async () => {
      const testIds = [
        '60d5ecb74f1a6b2f8c8b4567',
        'simple-id',
        'complex_product_id_123',
        '12345',
        'a'
      ];

      for (const productId of testIds) {
        const response = await request(app)
          .delete(`/api/cart/remove/${productId}`)
          .expect('Content-Type', /json/);

        expect([200, 404]).toContain(response.status);
        expect(response.body).toHaveProperty('success');
      }
    });

    it('should handle URL encoded productIds', async () => {
      const encodedId = encodeURIComponent('product with spaces & symbols');
      
      const response = await request(app)
        .delete(`/api/cart/remove/${encodedId}`)
        .expect('Content-Type', /json/);

      expect([200, 404]).toContain(response.status);
    });

    it('should not allow other HTTP methods on remove endpoint', async () => {
      const productId = '60d5ecb74f1a6b2f8c8b4567';

      await request(app)
        .get(`/api/cart/remove/${productId}`)
        .expect(404);

      await request(app)
        .post(`/api/cart/remove/${productId}`)
        .expect(404);

      await request(app)
        .put(`/api/cart/remove/${productId}`)
        .expect(404);
    });
  });

  describe('DELETE /api/cart/clear', () => {
    it('should clear entire cart successfully', async () => {
      const response = await request(app)
        .delete('/api/cart/clear')
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('message', 'Cart cleared successfully');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('items', []);
      expect(response.body.data).toHaveProperty('itemCount', 0);
      expect(response.body.data).toHaveProperty('total', 0);
    });

    it('should return empty cart structure after clearing', async () => {
      const response = await request(app)
        .delete('/api/cart/clear')
        .expect(200);

      const { data } = response.body;
      expect(data).toMatchObject({
        id: expect.any(String),
        user: expect.any(String),
        items: [],
        itemCount: 0,
        total: 0,
        currency: expect.any(String),
        lastUpdated: expect.any(String),
        createdAt: expect.any(String),
        updatedAt: expect.any(String)
      });
    });

    it('should not allow other HTTP methods on clear endpoint', async () => {
      await request(app)
        .get('/api/cart/clear')
        .expect(404);

      await request(app)
        .post('/api/cart/clear')
        .expect(404);

      await request(app)
        .put('/api/cart/clear')
        .expect(404);
    });
  });

  describe('GET /api/cart/count', () => {
    it('should get cart count successfully', async () => {
      const response = await request(app)
        .get('/api/cart/count')
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toHaveProperty('success', true);
      expect(response.body).toHaveProperty('message', 'Cart count retrieved successfully');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('itemCount');
      expect(response.body.data).toHaveProperty('total');
      expect(typeof response.body.data.itemCount).toBe('number');
      expect(typeof response.body.data.total).toBe('number');
      expect(response.body.data.itemCount).toBeGreaterThanOrEqual(0);
      expect(response.body.data.total).toBeGreaterThanOrEqual(0);
    });

    it('should return lightweight response structure', async () => {
      const response = await request(app)
        .get('/api/cart/count')
        .expect(200);

      const { data } = response.body;
      
      // Should only contain count and total, not full cart details
      expect(Object.keys(data)).toEqual(['itemCount', 'total']);
      expect(data).not.toHaveProperty('items');
      expect(data).not.toHaveProperty('id');
      expect(data).not.toHaveProperty('user');
    });

    it('should not allow other HTTP methods on count endpoint', async () => {
      await request(app)
        .post('/api/cart/count')
        .expect(404);

      await request(app)
        .put('/api/cart/count')
        .expect(404);

      await request(app)
        .delete('/api/cart/count')
        .expect(404);
    });
  });

  describe('HTTP Method Validation', () => {
    it('should validate HTTP methods for each endpoint', async () => {
      const endpointMethods = [
        { path: '/api/cart', allowedMethods: ['GET'], disallowedMethods: ['POST', 'PUT', 'DELETE'] },
        { path: '/api/cart/add', allowedMethods: ['POST'], disallowedMethods: ['GET', 'PUT', 'DELETE'] },
        { path: '/api/cart/update/testId', allowedMethods: ['PUT'], disallowedMethods: ['GET', 'POST', 'DELETE'] },
        { path: '/api/cart/remove/testId', allowedMethods: ['DELETE'], disallowedMethods: ['GET', 'POST', 'PUT'] },
        { path: '/api/cart/clear', allowedMethods: ['DELETE'], disallowedMethods: ['GET', 'POST', 'PUT'] },
        { path: '/api/cart/count', allowedMethods: ['GET'], disallowedMethods: ['POST', 'PUT', 'DELETE'] }
      ];

      for (const endpoint of endpointMethods) {
        for (const method of endpoint.disallowedMethods) {
          const response = await request(app)[method.toLowerCase() as keyof typeof request](endpoint.path);
          expect([404, 405]).toContain(response.status);
        }
      }
    });
  });

  describe('Content-Type Handling', () => {
    it('should handle different content types appropriately', async () => {
      const validData = {
        productId: '60d5ecb74f1a6b2f8c8b4567',
        quantity: 2
      };

      // JSON content type (should work)
      const jsonResponse = await request(app)
        .post('/api/cart/add')
        .set('Content-Type', 'application/json')
        .send(JSON.stringify(validData))
        .expect('Content-Type', /json/);

      expect([200, 400]).toContain(jsonResponse.status);

      // Form data (may or may not be supported)
      const formResponse = await request(app)
        .post('/api/cart/add')
        .set('Content-Type', 'application/x-www-form-urlencoded')
        .send('productId=60d5ecb74f1a6b2f8c8b4567&quantity=2');

      expect([200, 400, 415]).toContain(formResponse.status);

      // Text plain (should be rejected)
      const textResponse = await request(app)
        .post('/api/cart/add')
        .set('Content-Type', 'text/plain')
        .send('some text data');

      expect([400, 415]).toContain(textResponse.status);
    });

    it('should always respond with JSON content type', async () => {
      const endpoints = [
        { method: 'get', path: '/api/cart' },
        { method: 'post', path: '/api/cart/add', data: { productId: 'test', quantity: 1 } },
        { method: 'put', path: '/api/cart/update/test', data: { quantity: 2 } },
        { method: 'delete', path: '/api/cart/remove/test' },
        { method: 'delete', path: '/api/cart/clear' },
        { method: 'get', path: '/api/cart/count' }
      ];

      for (const endpoint of endpoints) {
        const req = request(app)[endpoint.method as keyof typeof request](endpoint.path);
        
        if (endpoint.data) {
          req.send(endpoint.data);
        }

        const response = await req;
        expect(response.headers['content-type']).toMatch(/json/);
      }
    });
  });

  describe('Response Format Consistency', () => {
    it('should maintain consistent success response format', async () => {
      const successEndpoints = [
        { method: 'get', path: '/api/cart' },
        { method: 'post', path: '/api/cart/add', data: { productId: 'test', quantity: 1 } },
        { method: 'put', path: '/api/cart/update/test', data: { quantity: 2 } },
        { method: 'delete', path: '/api/cart/remove/test' },
        { method: 'delete', path: '/api/cart/clear' },
        { method: 'get', path: '/api/cart/count' }
      ];

      for (const endpoint of successEndpoints) {
        const req = request(app)[endpoint.method as keyof typeof request](endpoint.path);
        
        if (endpoint.data) {
          req.send(endpoint.data);
        }

        const response = await req;
        
        if (response.status === 200) {
          expect(response.body).toHaveProperty('success', true);
          expect(response.body).toHaveProperty('message');
          expect(response.body).toHaveProperty('data');
          expect(typeof response.body.message).toBe('string');
        }
      }
    });

    it('should maintain consistent error response format', async () => {
      const errorScenarios = [
        { method: 'post', path: '/api/cart/add', data: {} }, // Missing required fields
        { method: 'post', path: '/api/cart/add', data: { productId: 'test', quantity: 0 } }, // Invalid quantity
        { method: 'put', path: '/api/cart/update/test', data: {} }, // Missing quantity
        { method: 'put', path: '/api/cart/update/test', data: { quantity: -1 } } // Invalid quantity
      ];

      for (const scenario of errorScenarios) {
        const req = request(app)[scenario.method as keyof typeof request](scenario.path);
        req.send(scenario.data);

        const response = await req;
        
        if (response.status >= 400) {
          expect(response.body).toHaveProperty('success', false);
          expect(response.body).toHaveProperty('message');
          expect(typeof response.body.message).toBe('string');
          
          if (response.body.errors) {
            expect(Array.isArray(response.body.errors)).toBe(true);
            response.body.errors.forEach((error: any) => {
              expect(error).toHaveProperty('field');
              expect(error).toHaveProperty('message');
            });
          }
        }
      }
    });
  });

  describe('Edge Cases and Error Handling', () => {
    it('should handle large payload gracefully', async () => {
      const largeData = {
        productId: 'x'.repeat(10000), // Very long product ID
        quantity: 999999999999999 // Very large number
      };

      const response = await request(app)
        .post('/api/cart/add')
        .send(largeData)
        .expect('Content-Type', /json/);

      expect([200, 400, 413, 500]).toContain(response.status);
      expect(response.body).toHaveProperty('success');
    });

    it('should handle special characters and encoding', async () => {
      const specialData = {
        productId: 'product-🛒-with-emoji-产品-المنتج',
        quantity: 1
      };

      const response = await request(app)
        .post('/api/cart/add')
        .send(specialData)
        .expect('Content-Type', /json/);

      expect([200, 400]).toContain(response.status);
      expect(response.body).toHaveProperty('success');
    });

    it('should handle null and undefined values', async () => {
      const nullData = {
        productId: null,
        quantity: undefined
      };

      const response = await request(app)
        .post('/api/cart/add')
        .send(nullData)
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response.body).toHaveProperty('success', false);
    });

    it('should handle empty strings appropriately', async () => {
      const emptyData = {
        productId: '',
        quantity: ''
      };

      const response = await request(app)
        .post('/api/cart/add')
        .send(emptyData)
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response.body).toHaveProperty('success', false);
    });

    it('should handle concurrent operations gracefully', async () => {
      const operations = [
        request(app).get('/api/cart'),
        request(app).post('/api/cart/add').send({ productId: 'test1', quantity: 1 }),
        request(app).post('/api/cart/add').send({ productId: 'test2', quantity: 2 }),
        request(app).get('/api/cart/count'),
        request(app).delete('/api/cart/clear')
      ];

      const responses = await Promise.all(operations);
      
      responses.forEach(response => {
        expect(response.body).toHaveProperty('success');
        expect(['boolean', 'undefined']).toContain(typeof response.body.success);
      });
    });
  });

  describe('Performance and Load Testing', () => {
    it('should handle multiple rapid requests', async () => {
      const rapidRequests = Array(10).fill(null).map(() => 
        request(app).get('/api/cart/count')
      );

      const responses = await Promise.all(rapidRequests);
      
      responses.forEach(response => {
        expect([200, 429, 500]).toContain(response.status); // 429 if rate limited
        expect(response.body).toHaveProperty('success');
      });
    });

    it('should respond within reasonable time limits', async () => {
      const startTime = Date.now();
      
      await request(app)
        .get('/api/cart')
        .expect(200);
        
      const endTime = Date.now();
      const responseTime = endTime - startTime;
      
      // Should respond within 5 seconds for mock implementation
      expect(responseTime).toBeLessThan(5000);
    });
  });
});