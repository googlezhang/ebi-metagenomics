<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="content-full">
    <h2>All Biomes</h2>

<c:choose>
    <c:when test="${not empty biome_counter}">

        <table border="1" class="table-heading result" id="list-biomes">
            <thead>
                <tr>
                    <th>Biome</th>
                    <th class="biome" abbr="Biome" scope="col">Lineage</th>
                    <th class="number-projects" abbr="num_proj" scope="col">Number of Projects</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="biome" items="${biome_counter}" varStatus="status">
                    <tr>
                        <td>
                            <span style="display: none">${biome[1].lineage}</span>
                            <span class="biome_icon icon_xs ${biome[1].cssClass}"
                                  title="${biome[1].iconTitle} biome"></span>
                        </td>
                        <td>
                            <a href="projects/doSearch?searchTerm=&biomeLineage=${biome[1].lineage}&search=Search">${biome[1].biomeName}</a><br/>
                            ${biome[1].formattedLineage}
                        </td>
                        <td>
                            <a href="projects/doSearch?searchTerm=&biomeLineage=${biome[1].lineage}&search=Search">${biome[0]}</a>
                        </td>
                    </tr>

                </c:forEach>
            </tbody>
        </table>
        <br/>
        <script>
            $(document).ready(function() {
                $('#list-biomes').DataTable({
                  "columnDefs": [ //add style to the different columns as direct css doesn't work
                        {className: "table-align-center table-sm-width", "targets": [0, 2]},
                    ],
                    "oLanguage": {
                        "sSearch": "Filter:"
                    },
                    "lengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]]
                });

                $("#list-biomes_filter input").addClass("filter_sp");

                // Highlight the search term in the table using the filter input, using jQuery Highlight plugin
                $('.filter_sp').keyup(function () {
                    $("#list-biomes tr td").highlight($(this).val());
                    // console.log($(this).val());
                    $('#list-biomes tr td').unhighlight();// highlight more than just first character entered in the text box and reiterate the span to highlight
                    $('#list-biomes tr td').highlight($(this).val());

                });
                // remove highlight when click on X (clear button)
                $('input[type=search]').on('search', function () {
                    $('#list-biomes tr td').unhighlight();
                });

            } );
        </script>
    </c:when>
    <c:otherwise>
        <div class="msg_error">No biome-data was recovered</div>
    </c:otherwise>
</c:choose>

</div>