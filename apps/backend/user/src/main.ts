import { createApp } from './app.js';
import { AppConfig } from './config/app-config.js';

const app = await createApp();
await app.listen(app.get(AppConfig).env.PORT, '0.0.0.0');
