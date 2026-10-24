import { SwaggerModule } from '@nestjs/swagger';
import { buildOpenApi, createApp } from './app.js';
import { AppConfig } from './config/app-config.js';

const app = await createApp();
const config = app.get(AppConfig);

if (!config.isProduction) {
  SwaggerModule.setup('docs', app, () => buildOpenApi(app));
}

await app.listen(config.env.PORT, '0.0.0.0');
