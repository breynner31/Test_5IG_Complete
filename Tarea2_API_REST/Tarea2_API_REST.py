"""
Tarea 2: Trabajando con APIs REST
Script para interactuar con JSONPlaceholder API
Autor: Breynner Sierra
"""
import requests
import json
import sys
from typing import Dict, List, Optional
from datetime import datetime

class JSONPlaceholderAPI:
    """
    Clase para interactuar con la API JSONPlaceholder
    Documentación: https://jsonplaceholder.typicode.com/
    """
    
    def __init__(self, base_url: str = "https://jsonplaceholder.typicode.com"):

        self.base_url = base_url
        self.session = requests.Session()
        # Configurar headers para mejor compatibilidad
        self.session.headers.update({
            'Content-Type': 'application/json',
            'User-Agent': 'LibraryManagementSystem/1.0'
        })
    
    def get_posts(self, limit: int = 5) -> Optional[List[Dict]]:
        """
        Obtiene una lista de posts desde la API
        
        Args:
            limit (int): Número máximo de posts a obtener

        """
        try:
            print(f"Obteniendo {limit} posts desde {self.base_url}/posts...")
            
            response = self.session.get(f"{self.base_url}/posts")
            
            # Verificar código de estado HTTP
            if response.status_code == 200:
                posts = response.json()
                # Limitar el número de posts
                limited_posts = posts[:limit]
                
                print(f"Se obtuvieron {len(limited_posts)} posts exitosamente")
                return limited_posts
            else:
                print(f"Error HTTP {response.status_code}: {response.reason}")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"Error de conexión: {e}")
            return None
        except json.JSONDecodeError as e:
            print(f"Error al decodificar JSON: {e}")
            return None
    
    def get_post_by_id(self, post_id: int) -> Optional[Dict]:
        """
        Obtiene un post específico por su ID
        
        Args:
            post_id (int): ID del post a obtener
        """
        try:
            print(f"Obteniendo post con ID {post_id}...")
            
            response = self.session.get(f"{self.base_url}/posts/{post_id}")
            
            if response.status_code == 200:
                post = response.json()
                print(f"Post obtenido exitosamente")
                return post
            elif response.status_code == 404:
                print(f"Post con ID {post_id} no encontrado")
                return None
            else:
                print(f"Error HTTP {response.status_code}: {response.reason}")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"Error de conexión: {e}")
            return None
    
    def create_post(self, title: str, body: str, user_id: int = 1) -> Optional[Dict]:
        """
        Crea un nuevo post en la API
        
        Args:
            title (str): Título del post
            body (str): Contenido del post
            user_id (int): ID del usuario que crea el post
        """
        try:
            print(f"Creando nuevo post...")
            
            # Datos del nuevo post
            new_post = {
                "title": title,
                "body": body,
                "userId": user_id
            }
            
            response = self.session.post(
                f"{self.base_url}/posts",
                json=new_post
            )
            
            if response.status_code == 201:
                created_post = response.json()
                print(f"Post creado exitosamente con ID: {created_post.get('id', 'N/A')}")
                return created_post
            else:
                print(f"Error HTTP {response.status_code}: {response.reason}")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"Error de conexión: {e}")
            return None
        except json.JSONDecodeError as e:
            print(f"Error al decodificar respuesta: {e}")
            return None
    
    def extract_post_info(self, posts: List[Dict]) -> List[Dict]:
        """
        Extrae información específica de los posts
        
        Args:
            posts (List[Dict]): Lista de posts completos

        """
        extracted_info = []
        
        for post in posts:
            # Extraer solo la información relevante
            info = {
                "id": post.get("id"),
                "title": post.get("title"),
                "user_id": post.get("userId"),
                "title_length": len(post.get("title", "")),
                "body_preview": post.get("body", "")[:50] + "..." if len(post.get("body", "")) > 50 else post.get("body", "")
            }
            extracted_info.append(info)
        
        return extracted_info
    
    def display_posts_summary(self, posts: List[Dict]) -> None:
        """
        Muestra un resumen de los posts obtenidos
        
        Args:
            posts (List[Dict]): Lista de posts
        """
        if not posts:
            print("No hay posts para mostrar")
            return
        
        print(f"\nRESUMEN DE POSTS ({len(posts)} posts):")
        print("=" * 60)
        
        for post in posts:
            print(f"ID: {post.get('id')}")
            print(f"Título: {post.get('title')}")
            print(f"Usuario ID: {post.get('userId')}")
            print(f"Vista previa: {post.get('body', '')[:80]}...")
            print("-" * 40)

def main():
    """
    Función principal que demuestra el uso de la API
    """
    print("INICIANDO DEMOSTRACIÓN DE API REST")
    print("=" * 50)
    
    # Crear instancia de la API
    api = JSONPlaceholderAPI()
    
    # 1. OBTENER POSTS (GET Request)
    print("\nPASO 1: Obtener posts existentes")
    posts = api.get_posts(limit=3)
    
    if posts:
        # Mostrar resumen
        api.display_posts_summary(posts)
        
        # Extraer información específica
        print("\nPASO 2: Extraer información específica")
        extracted_info = api.extract_post_info(posts)
        
        print("Información extraída:")
        for info in extracted_info:
            print(f"  • Post {info['id']}: '{info['title']}' (Longitud: {info['title_length']} chars)")
            print(f"    Vista previa: {info['body_preview']}")
    
    # 2. OBTENER POST ESPECÍFICO
    print("\nPASO 3: Obtener post específico")
    specific_post = api.get_post_by_id(1)
    
    if specific_post:
        print(f"Post específico:")
        print(f"  Título: {specific_post.get('title')}")
        print(f"  Usuario: {specific_post.get('userId')}")
    
    # 3. CREAR NUEVO POST (POST Request)
    print("\nPASO 4: Crear nuevo post")
    
    # Datos del nuevo post relacionado con biblioteca
    new_post_data = {
        "title": "Nuevo sistema de gestión de biblioteca implementado",
        "body": "La Universidad de los Andes ha implementado exitosamente el nuevo sistema de gestión de biblioteca desarrollado por 5IG Solutions. El sistema permite un mejor control de préstamos y organización de libros.",
        "user_id": 1
    }
    
    created_post = api.create_post(
        title=new_post_data["title"],
        body=new_post_data["body"],
        user_id=new_post_data["user_id"]
    )
    
    if created_post:
        print(f"Post creado:")
        print(f"  ID: {created_post.get('id')}")
        print(f"  Título: {created_post.get('title')}")
        print(f"  Usuario: {created_post.get('userId')}")
    
    # 4. DEMOSTRAR MANEJO DE ERRORES
    print("\nPASO 5: Demostrar manejo de errores")
    
    # Intentar obtener un post que no existe
    print("Intentando obtener post inexistente (ID: 999)...")
    non_existent_post = api.get_post_by_id(999)
    
    if non_existent_post is None:
        print("Manejo de error funcionando correctamente")
    
    print("\nDEMOSTRACIÓN COMPLETADA")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nPrograma interrumpido por el usuario")
        sys.exit(0)
    except Exception as e:
        print(f"\nError inesperado: {e}")
        sys.exit(1) 