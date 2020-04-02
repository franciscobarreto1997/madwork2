import autoComplete from 'js-autocomplete';

const autocomplete = () => {
  const search = document.getElementById('search');

  if (search) {

    new autoComplete({
      selector: search,
      minChars: 1,
      source: function(term, suggest){
          term = term.toLowerCase();
          var choices = ['Java', 'C', 'C++', 'Python', 'Visual Basic', '.Net', 'Javascript', 'C#', 'PHP', 'SQL', 'Objective-C', 'MATLAB', 'R', 'Ruby', 'Perl', 'Assembly', 'Swift', 'Elixir', 'Lua', 'React', 'Angular', 'Django', 'Ruby on Rails', 'Laravel', 'Vue', 'Scala', 'Node', 'Backend Developer', 'Front end Developer', 'Machine Learning', 'Data Science', 'Android Developer', 'iOS Developer', 'Haskell', 'Bash', 'Go'].sort();
          var matches = [];
          for (let i=0; i<choices.length; i++)
              if (~choices[i].toLowerCase().indexOf(term)) matches.push(choices[i]);
          suggest(matches);
      }
    });
  }
}

export default autocomplete;
