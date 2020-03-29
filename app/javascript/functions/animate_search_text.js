import Typed from 'typed.js';

const animateSearchText = () => {
  const search = document.getElementById('search')

  if (search) {
    let options = {
      strings: ['ruby on rails', 'node JS', 'python', 'laravel', '.net', 'elixir', 'iOS developer', 'front end developer', 'react', 'php', 'backend developer', 'scala'],
      typeSpeed: 80,
      loop: true,
      bindInputFocusEvents: true
    };

    let typed = new Typed(search, options);
  }
}

export default animateSearchText;
