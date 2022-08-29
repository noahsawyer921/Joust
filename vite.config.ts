import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import react from '@vitejs/plugin-react';
import StimulusHMR from 'vite-plugin-stimulus-hmr';
import FullReload from 'vite-plugin-full-reload';
import path from 'path';

export default defineConfig({
    plugins: [
        RubyPlugin(),
        react(),
        StimulusHMR(),
        FullReload(['config/routes.rb', 'app/views/**/*']),
    ],
    resolve: {
        alias: {
            $game: path.resolve(__dirname, 'app/frontend/game'),
        },
    },
});
