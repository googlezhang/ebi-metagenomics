package uk.ac.ebi.interpro.metagenomics.memi.dao.hibernate;

import org.hibernate.criterion.Criterion;
import uk.ac.ebi.interpro.metagenomics.memi.model.hibernate.Study;
import uk.ac.ebi.interpro.metagenomics.memi.model.valueObjects.StudyStatisticsVO;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * Represents the data access object interface for studies.
 *
 * @author Maxim Scheremetjew, EMBL-EBI, InterPro
 * @version $Id$
 * @since 1.0-SNAPSHOT
 */
public interface StudyDAO extends ISecureEntityDAO<Study> {

    /**
     * Retrieves studies order by the specified property.
     */
    List<Study> retrieveStudiesOrderBy(String propertyName, boolean isDescendingOrder);

    /**
     * Returns an ordered list of studies.
     *
     * @param propertyName      Name of the column for which the result should be order by.
     * @param isDescendingOrder Order direction.
     */
    List<Study> retrieveOrderedPublicStudies(String propertyName, boolean isDescendingOrder, int maxResult);

    /**
     * Returns an ordered list of studies by submitter ID..
     *
     * @param submissionAccountId Submitter ID for the IS equal restriction.
     * @param propertyName        Name of the column for which the result should be order by.
     * @param isDescendingOrder   Order direction
     */
    List<Study> retrieveOrderedStudiesBySubmitter(String submissionAccountId, String propertyName, boolean isDescendingOrder, int maxResult);

    /**
     * Returns a list of public studies where the submitter ID IS equal the specified submitter ID.
     *
     * @param submissionAccountId Submitter ID for the IS equal restriction.
     */
    List<Study> retrieveStudiesBySubmitter(String submissionAccountId);

    /**
     * Returns an ordered list of public studies where the submitter ID IS NOT equal the specified submitter ID.
     *
     * @param submitterId       Submitter ID for the NOT equal restriction.
     * @param propertyName      Name of the column for which the result should be order by.
     * @param isDescendingOrder Order direction.
     */
    List<Study> retrieveOrderedPublicStudiesWithoutSubId(long submitterId, String propertyName, boolean isDescendingOrder);

    /**
     * Returns a list of public studies where the submitter ID IS NOT equal the specified submitter ID.
     *
     * @param submitterId Submitter ID for the NOT equal restriction.
     */
    List<Study> retrievePublicStudiesWithoutSubId(long submitterId);

    /**
     * Returns a list of studies by the specified criteria.
     */
    List<Study> retrieveFilteredStudies(List<Criterion> crits);


    /**
     * Returns a list of asc ordered studies by the specified criteria.
     */
    List<Study> retrieveFilteredStudies(List<Criterion> crits, Boolean isDescendingOrder, String propertyName);

    /**
     * Returns a sub list of studies by the specified criteria. This method is used for pagination.
     *
     * @param crits         A list of criteria which should be add to the Hibernate query.
     * @param startPosition Used for pagination. In terms of Oracle this parameter specifies the row number of the first entry which should be selected.
     * @param pageSize      Used for pagination.Specifies how many entries should be selected for the specified page.
     * @return Filtered list of studies.
     */
    List<Study> retrieveFilteredStudies(List<Criterion> crits, Integer startPosition, Integer pageSize, Boolean isDescendingOrder, String propertyName);


    Study readByStringId(String studyId);

    /**
     * @return Number of all public studies.
     */
    Long countAllPublic();

    /**
     * @return Number of all studies not equals a specific isPublic value.
     */
    Long countAllWithNotEqualsEx(int isPublic);


    /**
     * Counts studies by criteria.
     *
     * @param crits A list of Hibernate criteria which should be add to the Hibernate query.
     * @return
     */
    Long countByCriteria(List<Criterion> crits);

    Long countPublicStudiesFilteredByBiomes(Collection<Integer> biomeIds);

    /**
     * Retrieves the number of runs for each study.
     * <p/>
     * Example result:
     * <p/>
     * ERP005249	2
     * ERP010153	3
     *
     * @param externalStudyIds List of external study identifiers.
     * @return
     */
    Map<String, Long> retrieveRunCountsGroupedByExternalStudyId(Collection<String> externalStudyIds);

    /**
     * Retrieves the number of samples for each study.
     * <p/>
     * Example result:
     * <p/>
     * ERP005249	1
     * ERP010153	1
     *
     * @param externalStudyIds List of external study identifiers.
     * @return
     */
    Map<String, Long> retrieveSampleCountsGroupedByExternalStudyId(Collection<String> externalStudyIds);

    public StudyStatisticsVO retrieveStatistics();
}