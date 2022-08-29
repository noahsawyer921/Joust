import { MotionConfig } from 'framer-motion';
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter, Route, Routes } from 'react-router-dom';

import App from '$game/App';
import { QueryClientProvider } from 'react-query';
import { queryClient } from '$game/queries';
import Waiting from '$game/pages/Waiting';
import Voting from '$game/pages/Voting';
import Bracket from '$game/pages/Bracket';
import Countdown from '$game/pages/Countdown';
import Matchup from '$game/pages/Matchup';
import Finish from '$game/pages/Finish';

const rootElement = document.getElementById('root');
const root = createRoot(rootElement!);

root.render(
    <StrictMode>
        <BrowserRouter basename="/game">
            <QueryClientProvider client={queryClient}>
                <MotionConfig reducedMotion="user">
                    <Routes>
                        <Route path="/" element={<App />}>
                            <Route path="/waiting" element={<Waiting />} />
                            <Route path="/voting" element={<Voting />} />
                            <Route path="/round/:id" element={<Bracket />} />
                            <Route path="/countdown" element={<Countdown />} />
                            <Route path="/matchups/:id" element={<Matchup />} />
                            <Route path="/finish" element={<Finish />} />
                        </Route>
                    </Routes>
                </MotionConfig>
            </QueryClientProvider>
        </BrowserRouter>
    </StrictMode>
);
