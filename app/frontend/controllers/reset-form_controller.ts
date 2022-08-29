import { Controller } from 'stimulus';

function isForm(element: Element): element is HTMLFormElement {
    return 'reset' in element && 'elements' in element;
}

export default class extends Controller {
    reset() {
        const form = this.element;
        if (isForm(form)) {
            form.reset();

            for (const element of form.elements) {
                if (element.getAttribute('type') !== 'hidden') {
                    (element as HTMLElement)?.focus();
                    break;
                }
            }
        }
    }
}
