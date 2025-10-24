import request from 'supertest';
import app from './server';

describe('Health endpoint', () => {
  it('GET /health should return 200 and expected shape', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body).toHaveProperty('message');
    expect(res.body).toHaveProperty('environment');
    expect(res.body).toHaveProperty('version');
    expect(res.body).toHaveProperty('endpoints');
  });
});
