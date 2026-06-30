import { useEffect } from 'react';
import { useDeck } from './store/useDeck';
import { DeckScreen } from './components/DeckScreen';

export default function App() {
  const init = useDeck((s) => s.init);
  const loading = useDeck((s) => s.loading);
  const deckReady = useDeck((s) => s.currentDeck.length > 0);

  useEffect(() => {
    void init();
  }, [init]);

  if (loading && !deckReady) {
    return (
      <div
        style={{
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          background: 'rgb(245,245,247)',
          color: 'rgb(120,120,130)',
          fontSize: 15,
        }}
      >
        …
      </div>
    );
  }

  return <DeckScreen />;
}
