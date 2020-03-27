import Typed from 'typed.js';

const animateSearchText = () => {
  const search = document.getElementById('search')

  let options = {
    strings: ['ruby on rails', 'node JS', 'python', 'laravell', '.net', 'elixir', 'iOS developer', 'front end developer', 'react', 'php', 'backend developer', 'scala', 'ruby on rails', 'node JS', 'python', 'laravell', '.net', 'elixir', 'iOS developer', 'front end developer', 'react', 'php', 'backend developer', 'scala'],
    typeSpeed: 80
  };

  let typed = new Typed(search, options);
}

export default animateSearchText;
