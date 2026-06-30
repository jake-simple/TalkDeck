import { useEffect, useRef } from 'react';

/**
 * 토스 네비게이션 바의 뒤로가기(웹뷰 history back)로 오버레이를 닫기 위한 훅.
 *
 * - 오버레이가 열리면 history 항목을 하나 push 한다.
 * - 뒤로가기(popstate)가 발생하면 onClose 를 호출해 오버레이를 닫는다.
 * - 닫기 버튼/선택 등 코드로 닫히면, push 했던 history 항목을 되돌려(history.back) 스택을 깔끔히 유지한다.
 *
 * 이렇게 하면 오버레이가 열린 상태에서 뒤로가기를 누르면 미니앱이 즉시 종료되지 않고
 * "오버레이 닫힘 → (다시 누르면) 미니앱 종료" 순으로 자연스럽게 동작한다.
 */
export function useOverlayBack(open: boolean, onClose: () => void) {
  const closeRef = useRef(onClose);
  closeRef.current = onClose;
  const poppedByBack = useRef(false);

  useEffect(() => {
    if (!open) return;
    poppedByBack.current = false;
    window.history.pushState({ aitOverlay: true }, '');

    const onPop = () => {
      poppedByBack.current = true;
      closeRef.current();
    };
    window.addEventListener('popstate', onPop);

    return () => {
      window.removeEventListener('popstate', onPop);
      // 뒤로가기가 아닌 방식(닫기 버튼/선택)으로 닫혔으면 push 했던 항목을 제거
      if (!poppedByBack.current) {
        window.history.back();
      }
    };
  }, [open]);
}
