import { Application } from 'stimulus';
import { registerControllers } from 'stimulus-vite-helpers';

const application = Application.start();

const controllers = import.meta.globEager('./**/*_controller.ts');
registerControllers(application, controllers);
