<?xml version="1.0" encoding="UTF-8"?>
<!-- 13 — Kane Adama -->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:param name="seuil" select="10" />

    <!-- Clé utilisée pour regrouper les étudiants par classe -->
    <xsl:key name="par-classe" match="etudiant" use="@classe" />

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8" />
                <title>
                    <xsl:text>Promotion — </xsl:text>
                    <xsl:value-of select="promotion/@filiere" />
                </title>
                <link rel="stylesheet" href="style.css" />
            </head>

            <body>
                <header>
                    <h1>
                        <xsl:text>Liste des étudiants — </xsl:text>
                        <xsl:value-of select="promotion/@filiere" />
                    </h1>
                    <p>
                        <xsl:text>Année universitaire : </xsl:text>
                        <xsl:value-of select="promotion/@annee" />
                    </p>
                </header>

                <main>
                    <!-- Étape 7 : les quatre chiffres clés -->
                    <div class="stats">
                        <div class="carte">
                            <span class="valeur">
                                <xsl:value-of select="count(promotion/etudiant)" />
                            </span>
                            <span class="legende">Nombre d'étudiants</span>
                        </div>
                        <div class="carte">
                            <span class="valeur">
                                <xsl:value-of
                                    select="count(promotion/etudiant[sum(notes/note) div count(notes/note) &gt;= $seuil])" />
                            </span>
                            <span class="legende">Nombre d'admis</span>
                        </div>
                        <div class="carte">
                            <span class="valeur">
                                <xsl:value-of
                                    select="format-number(sum(promotion/etudiant/notes/note[@matiere='XML']) div count(promotion/etudiant/notes/note[@matiere='XML']), '0.00')" />
                            </span>
                            <span class="legende">Moyenne en XML</span>
                        </div>
                        <div class="carte">
                            <span class="valeur">
                                <xsl:value-of select="count(promotion/etudiant[not(email)])" />
                            </span>
                            <span class="legende">Emails manquants</span>
                        </div>
                    </div>

                    <!-- Étape 8 : un tableau par classe -->
                    <xsl:for-each
                        select="promotion/etudiant[generate-id() = generate-id(key('par-classe', @classe)[1])]">
                        <xsl:sort select="@classe" order="ascending" />
            <xsl:variable
                            name="classeCourante" select="@classe" />

            <h2>
                            <xsl:value-of select="$classeCourante" />
                            <xsl:text> — </xsl:text>
                            <xsl:value-of select="count(key('par-classe', $classeCourante))" />
                            <xsl:text> étudiants</xsl:text>
                        </h2>

            <table>
                            <thead>
                                <tr>
                                    <th>Rang</th>
                                    <th>Matricule</th>
                                    <th>Nom</th>
                                    <th>Prénom</th>
                                    <th>Classe</th>
                                    <th>Email</th>
                                    <th>Moyenne</th>
                                    <th>Résultat</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="key('par-classe', $classeCourante)">
                                    <xsl:sort select="sum(notes/note) div count(notes/note)"
                                        data-type="number" order="descending" />

                  <tr>
                                        <!-- Étape 9 : mettre en évidence le premier de chaque
                                        classe -->
                                        <xsl:if test="position() = 1">
                                            <xsl:attribute name="class">major</xsl:attribute>
                                        </xsl:if>

                                        <td class="rang">
                                            <xsl:value-of select="position()" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="@matricule" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="nom" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="prenom" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="@classe" />
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="email">
                                                    <xsl:value-of select="email" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <span class="absent">non renseigné</span>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td class="moyenne">
                                            <xsl:value-of
                                                select="format-number(sum(notes/note) div count(notes/note), '0.00')" />
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when
                                                    test="sum(notes/note) div count(notes/note) &gt;= $seuil">
                                                    <span class="badge reussite">Admis</span>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <span class="badge echec">À revoir</span>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </xsl:for-each>
                </main>

                <footer>Document généré à partir des données XML de la promotion.</footer>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>