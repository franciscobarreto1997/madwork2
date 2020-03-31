const inject = (list_of_cities) => {
  const selectCityElement = document.getElementById('city');

  if (selectCityElement) {
    selectCityElement.innerHTML = ""

    list_of_cities.forEach((city) => {
      selectCityElement.insertAdjacentHTML('beforeend', `<option value="${city.name}">${city.name}</option>`)
    })
  }
}

export default inject;
