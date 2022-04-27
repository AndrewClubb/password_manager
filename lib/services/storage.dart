import '../model/site.dart';

abstract class Storage {
  Future<List<Site>> getSites();

  Future<Site> insertSite(String url, String username, String password);

  Future<void> removeSite(Site site);
}