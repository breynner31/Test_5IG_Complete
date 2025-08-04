import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

// Test 5IG - Frontend Application - Updated for deployment
function App() {
  const [posts, setPosts] = useState([]);
  const [filteredPosts, setFilteredPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedUserId, setSelectedUserId] = useState('all');
  const [users, setUsers] = useState([]);

  // Obtener posts de la API y localStorage
  const fetchPosts = async () => {
    try {
      setLoading(true);
      setError(null);
      
      const response = await axios.get('https://jsonplaceholder.typicode.com/posts');
      const apiPosts = response.data;
      
      // Obtener posts guardados en localStorage
      const savedPosts = JSON.parse(localStorage.getItem('libraryPosts') || '[]');
      
      // Combinar posts de API con posts guardados localmente
      const allPosts = [...savedPosts, ...apiPosts];
      
      setPosts(allPosts);
      setFilteredPosts(allPosts);
      
      // Extraer usuarios únicos para el filtro
      const uniqueUsers = [...new Set(allPosts.map(post => post.userId))];
      setUsers(uniqueUsers);
      
    } catch (err) {
      setError('Error al cargar los posts. Por favor, intenta de nuevo.');
      console.error('Error fetching posts:', err);
    } finally {
      setLoading(false);
    }
  };

  // Crear nuevo post
  const createPost = async (title, body) => {
    try {
      setLoading(true);
      setError(null);
      
      const newPost = {
        title: title,
        body: body,
        userId: 1
      };
      
      const response = await axios.post('https://jsonplaceholder.typicode.com/posts', newPost);
      
      // Agregar el nuevo post a la lista
      const createdPost = { ...response.data, id: Date.now() }; // ID temporal
      const updatedPosts = [createdPost, ...posts];
      
      // Guardar en localStorage
      const savedPosts = JSON.parse(localStorage.getItem('libraryPosts') || '[]');
      const newSavedPosts = [createdPost, ...savedPosts];
      localStorage.setItem('libraryPosts', JSON.stringify(newSavedPosts));
      
      setPosts(updatedPosts);
      
      // Actualizar posts filtrados
      applyFilters(updatedPosts, searchTerm, selectedUserId);
      
      return true;
    } catch (err) {
      setError('Error al crear el post. Por favor, intenta de nuevo.');
      console.error('Error creating post:', err);
      return false;
    } finally {
      setLoading(false);
    }
  };

  // Aplicar filtros
  const applyFilters = (postsToFilter, search, userId) => {
    let filtered = postsToFilter;

    // Filtro por búsqueda
    if (search) {
      filtered = filtered.filter(post =>
        post.title.toLowerCase().includes(search.toLowerCase()) ||
        post.body.toLowerCase().includes(search.toLowerCase())
      );
    }

    // Filtro por usuario
    if (userId !== 'all') {
      filtered = filtered.filter(post => post.userId === parseInt(userId));
    }

    setFilteredPosts(filtered);
  };

  // Manejar cambios en la búsqueda
  const handleSearchChange = (e) => {
    const value = e.target.value;
    setSearchTerm(value);
    applyFilters(posts, value, selectedUserId);
  };

  // Manejar cambios en el filtro de usuario
  const handleUserFilterChange = (e) => {
    const value = e.target.value;
    setSelectedUserId(value);
    applyFilters(posts, searchTerm, value);
  };

  // Cargar datos al montar el componente
  useEffect(() => {
    fetchPosts();
  }, []);

  // Componente para crear nuevo post
  const CreatePostForm = () => {
    const [title, setTitle] = useState('');
    const [body, setBody] = useState('');
    const [isCreating, setIsCreating] = useState(false);

    const handleSubmit = async (e) => {
      e.preventDefault();
      if (!title.trim() || !body.trim()) return;

      setIsCreating(true);
      const success = await createPost(title, body);
      
      if (success) {
        setTitle('');
        setBody('');
      }
      setIsCreating(false);
    };

    return (
      <div className="card">
        <h3>Crear Nuevo Post</h3>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="title">Título:</label>
            <input
              type="text"
              id="title"
              className="input"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Ingresa el título del post"
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="body">Contenido:</label>
            <textarea
              id="body"
              className="input"
              value={body}
              onChange={(e) => setBody(e.target.value)}
              placeholder="Ingresa el contenido del post"
              rows="4"
              required
            />
          </div>
          <button 
            type="submit" 
            className="btn btn-primary"
            disabled={isCreating}
          >
            {isCreating ? 'Creando...' : 'Crear Post'}
          </button>
        </form>
      </div>
    );
  };

  // Componente para mostrar estadísticas
  const Statistics = () => {
    const savedPostsCount = JSON.parse(localStorage.getItem('libraryPosts') || '[]').length;
    
    const clearLocalStorage = () => {
      localStorage.removeItem('libraryPosts');
      fetchPosts(); // Recargar posts
    };
    
    return (
      <div className="card">
        <h3>Estadísticas</h3>
        <div className="stats-grid">
          <div className="stat-item">
            <span className="stat-number">{posts.length}</span>
            <span className="stat-label">Total de Posts</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{filteredPosts.length}</span>
            <span className="stat-label">Posts Filtrados</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{users.length}</span>
            <span className="stat-label">Usuarios Únicos</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{savedPostsCount}</span>
            <span className="stat-label">Posts Guardados</span>
          </div>
        </div>
        {savedPostsCount > 0 && (
          <div style={{ marginTop: '1rem', textAlign: 'center' }}>
            <button 
              className="btn btn-secondary"
              onClick={clearLocalStorage}
              style={{ fontSize: '0.875rem' }}
            >
              Limpiar Posts Guardados
            </button>
          </div>
        )}
      </div>
    );
  };

  // Componente para mostrar un post individual
  const PostCard = ({ post }) => (
    <div className="post-card">
      <div className="post-header">
        <h4 className="post-title">{post.title}</h4>
        <span className="post-user">Usuario {post.userId}</span>
      </div>
      <p className="post-body">{post.body}</p>
      <div className="post-footer">
        <span className="post-id">ID: {post.id}</span>
        <span className="post-length">{post.body.length} caracteres</span>
      </div>
    </div>
  );

  return (
    <div className="App">
      <header className="header">
        <div className="container">
          <h1>Sistema de Gestión de Biblioteca</h1>
          <p>Universidad de los Andes - 5IG Solutions</p>
        </div>
      </header>

      <main className="main">
        <div className="container">
          {/* Formulario para crear posts */}
          <CreatePostForm />

          {/* Estadísticas */}
          <Statistics />

          {/* Filtros y búsqueda */}
          <div className="filters-section">
            <div className="search-filter">
              <input
                type="text"
                className="input"
                placeholder="Buscar posts por título o contenido..."
                value={searchTerm}
                onChange={handleSearchChange}
              />
            </div>
            <div className="user-filter">
              <select
                className="input"
                value={selectedUserId}
                onChange={handleUserFilterChange}
              >
                <option value="all">Todos los usuarios</option>
                {users.map(userId => (
                  <option key={userId} value={userId}>
                    Usuario {userId}
                  </option>
                ))}
              </select>
            </div>
            <button 
              className="btn btn-secondary"
              onClick={fetchPosts}
              disabled={loading}
            >
              {loading ? 'Cargando...' : 'Actualizar'}
            </button>
          </div>

          {/* Mensajes de error o éxito */}
          {error && <div className="error">{error}</div>}

          {/* Lista de posts */}
          <div className="posts-section">
            {loading ? (
              <div className="loading">Cargando posts...</div>
            ) : filteredPosts.length === 0 ? (
              <div className="no-results">
                <p>No se encontraron posts que coincidan con los filtros.</p>
              </div>
            ) : (
              <div className="posts-grid">
                {filteredPosts.map(post => (
                  <PostCard key={post.id} post={post} />
                ))}
              </div>
            )}
          </div>
        </div>
      </main>

      <footer className="footer">
        <div className="container">
          <p>Desarrollado por Breynner Sierra para 5IG Solutions</p>
        </div>
      </footer>
    </div>
  );
}

export default App; 