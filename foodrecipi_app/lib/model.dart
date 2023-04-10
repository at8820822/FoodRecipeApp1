class RecipeModel{
  late String applabel;
  late String appimgUrl;
  late String appcalories;
  late String appurl;
RecipeModel(
    { this.applabel="label ",this.appimgUrl="image", this.appcalories="0.000", this.appurl="url" }
    );
factory RecipeModel.fromMap(Map recipe){
  return RecipeModel(
    applabel: recipe["label"],
    appimgUrl: recipe["image"],
    appcalories: recipe["calories"].toString(),
    appurl: recipe["url"],
  );
}
}