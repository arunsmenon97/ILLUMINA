/**
* @File Name : ILA_SearchZipCodeWrapper.cls
* @Description : wrapper class for Zip code search functionality
* @Author : ARUN
* @Last Modified By :
* @Last Modified On : November 28, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 28, 2024 |   | Initial Version
**/

public class ILA_SearchZipCodeWrapper {
	public String post_code;	//680312
	public String country;	//India
	public String country_abbreviation;	//IN
	public cls_places[] places;
	public class cls_places {
		public String place_name;	//Inchakundu B.O
		public String longitude;	//76.2917
		public String state;	//Kerala
		public String state_abbreviation;	//KL
		public String latitude;	//10.3833
	}
}