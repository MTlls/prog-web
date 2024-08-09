


$(function() {
  console.log("jQuery e jQuery UI estão carregados");

  $("#livro_titulo").autocomplete({
    source: "/livros/autocomplete",
    minLength: 1
  });

  $("#autor_nome").autocomplete({
    source: "/autors/autocomplete",
    minLength: 1
  });

  function autocompleteSource(request, response) {
    var searchType = $('#query').val(); // Obtém o tipo de pesquisa
    console.log("searchType:", searchType); // Debug

    $.ajax({
      url: '/search/autocomplete',
      dataType: 'json',
      data: {
        term: request.term,
        search_type: searchType
      },
      success: function(data) {
        console.log("Dados recebidos:", data); // Debug
        response(data);
      },
      error: function(xhr, status, error) {
        console.error("Erro na requisição AJAX:", error); // Debug
      }
    });
  }

  $("#query").autocomplete({
    source: autocompleteSource,
    minLength: 1
  });
});
